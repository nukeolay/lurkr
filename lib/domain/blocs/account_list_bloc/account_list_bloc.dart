import 'dart:typed_data';

import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/repositories/account_repositiory.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountListBloc extends Bloc<AccountListEvent, AccountListState> {
  AccountRepository accountRepository = AccountRepository();

  AccountListBloc() : super(AccountListStateStarting(accountList: []));

  @override
  Stream<AccountListState> mapEventToState(AccountListEvent accountListEvent) async* {
    //---------------ЗАПУСКАЕМ ПРИЛОЖЕНИЕ---------------//
    if (accountListEvent is AccountListEventStart) {
      List<Account> tempAccountList = await accountRepository.getAccountListFromSharedprefs();
      yield AccountListStateLoaded(accountList: tempAccountList);
    }

    //---------------ДОБАВЛЯЕМ АККАУНТ---------------//
    if (accountListEvent is AccountListEventAdd) {
      yield AccountListStateLoading(accountList: state.accountList);
      //проверяем нет ли уже такого аккаунта в списке, для этого в классе Account переопределил опреатор '=='
      if (state.accountList.contains(AccountRepository.getDummyAccount(userName: accountListEvent.accountName))) {
        yield AccountListStateError(accountList: state.accountList, errorText: 'Account already added');
      } else {
        try {
          Account tempAccount = await accountRepository.getAccountFromInternet(accountName: accountListEvent.accountName);
          state.accountList.insert(0, tempAccount);
          await accountRepository.saveAccountListToSharedprefs(accountList: state.accountList);
          yield AccountListStateLoaded(accountList: state.accountList);
        } on NoTriesLeftException {
          state.accountList.insert(0, AccountRepository.getDummyAccount(userName: accountListEvent.accountName, fullName: 'not updated'));
          await accountRepository.saveAccountListToSharedprefs(accountList: state.accountList);
          yield AccountListStateError(accountList: state.accountList, errorText: 'Oops! No tries left, please try again later');
        } on NoAccountException {
          yield AccountListStateError(accountList: state.accountList, errorText: 'Account not found');
        }
      }
    }

    //---------------УДАЛЯЕМ АККАУНТ---------------//
    if (accountListEvent is AccountListEventDelete) {
      yield AccountListStateLoading(accountList: state.accountList);
      state.accountList.remove(AccountRepository.getDummyAccount(userName: accountListEvent.accountName));
      await accountRepository.saveAccountListToSharedprefs(accountList: state.accountList);
      yield AccountListStateLoaded(accountList: state.accountList);
    }

    //---------------СОХРАНЕМ АВАТАРКУ---------------//
    if (accountListEvent is AccountListEventDownload) {
      yield AccountListStateLoading(accountList: state.accountList);
      bool isPermissionGranted = await Permission.storage.status.isGranted;
      if (isPermissionGranted) {
        Uint8List imageData = Uint8List.fromList(accountListEvent.account.savedProfilePic.codeUnits);
        await ImageGallerySaver.saveImage(Uint8List.fromList(imageData),
            quality: 100, name: 'instasnitch_avatar_${accountListEvent.account.username}');
        yield AccountListStateDownloaded(accountList: state.accountList);
      } else {
        PermissionStatus permissionStatus = await Permission.storage.request();
        if (permissionStatus.isGranted) {
          add(AccountListEventDownload(account: accountListEvent.account));
        } else {
          yield AccountListStateError(accountList: state.accountList, errorText: 'Permission to storage not granted');
        }
      }
    }
  }
}
