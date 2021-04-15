import 'dart:typed_data';

import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/models/updater.dart';
import 'package:Instasnitch/data/repositories/repositiory.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountListBloc extends Bloc<AccountListEvent, AccountListState> {
  Repository repository = Repository();

  AccountListBloc() : super(AccountListStateStarting(accountList: [], updater: Updater(lastTimeUpdated: 0, refreshPeriod: 0, isDark: false)));

  @override
  Stream<AccountListState> mapEventToState(AccountListEvent accountListEvent) async* {
    print('event: $accountListEvent');
    //--------------- ЗАПУСКАЕМ ПРИЛОЖЕНИЕ ---------------//
    if (accountListEvent is AccountListEventStart) {
      List<Account> tempAccountList = await repository.getAccountListFromSharedprefs();
      Updater updater = await repository.getUpdater();
      yield AccountListStateLoaded(accountList: tempAccountList, updater: updater);
    }

    //--------------- ДОБАВЛЯЕМ АККАУНТ ---------------//
    if (accountListEvent is AccountListEventAdd) {
      yield AccountListStateLoading(accountList: state.accountList, updater: state.updater);
      //проверяем нет ли уже такого аккаунта в списке, для этого в классе Account переопределил опреатор '=='
      if (state.accountList.contains(Repository.getDummyAccount(userName: accountListEvent.accountName))) {
        yield AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'Account already added');
      } else {
        try {
          Account tempAccount = await repository.getAccountFromInternet(accountName: accountListEvent.accountName);
          state.accountList.insert(0, tempAccount);
          await repository.saveAccountListToSharedprefs(accountList: state.accountList);
          state.updater = Updater(lastTimeUpdated: DateTime.now().microsecondsSinceEpoch, refreshPeriod: state.updater.refreshPeriod, isDark: state.updater.isDark);
          await repository.saveUpdater(updater: state.updater);
          yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
        } on NoTriesLeftException {
          state.accountList.insert(0, Repository.getDummyAccount(userName: accountListEvent.accountName, fullName: 'info not loaded'));
          await repository.saveAccountListToSharedprefs(accountList: state.accountList);
          yield AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'Oops! No tries left, please try again later');
        } on NoAccountException {
          yield AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'Account not found: ${accountListEvent.accountName}');
        } on ConnectionException {
          yield AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'Network error');
        }
      }
    }

    //--------------- УДАЛЯЕМ АККАУНТ ---------------//
    if (accountListEvent is AccountListEventDelete) {
      yield AccountListStateLoading(accountList: state.accountList, updater: state.updater);
      state.accountList.remove(accountListEvent.account);
      await repository.saveAccountListToSharedprefs(accountList: state.accountList);
      yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
    }

    //--------------- СОХРАНЕМ АВАТАРКУ ---------------//
    if (accountListEvent is AccountListEventDownload) {
      yield AccountListStateLoading(accountList: state.accountList, updater: state.updater);
      bool isPermissionGranted = await Permission.storage.status.isGranted;
      if (isPermissionGranted) {
        Uint8List imageData = Uint8List.fromList(accountListEvent.account.savedProfilePic.codeUnits);
        dynamic result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageData),
            quality: 100, name: 'instasnitch_avatar_${accountListEvent.account.username}');
        if (result['error'] != null) {
          yield AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'Image was not saved: ${result['error'].toString()}');
        } else {
          yield AccountListStateDownloaded(accountList: state.accountList, updater: state.updater, snackbarText: 'Image saved');
        }
      } else {
        PermissionStatus permissionStatus = await Permission.storage.request();
        if (permissionStatus.isGranted) {
          add(AccountListEventDownload(account: accountListEvent.account));
        } else {
          yield AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'Permission to storage not granted');
        }
      }
    }

    //--------------- ОБНОВЛЯЕМ АККАУНТ ---------------//
    if (accountListEvent is AccountListEventRefresh) {
      yield AccountListStateLoading(accountList: state.accountList, updater: state.updater);
      try {
        Account tempAccount = await repository.getAccountFromInternet(accountName: accountListEvent.account.username);
        int accountNumber = state.accountList.indexOf(accountListEvent.account);
        if (tempAccount.isPrivate != state.accountList[accountNumber].isPrivate || state.accountList[accountNumber].isChanged == true) {
          //ставим isChanged в true, если статус приватности изменился. А отключить его можно только по тапу (включается при изменении статуса, а отключается по тапу)
          //или если аккаунт уже менял статус приватности до этого обновления, но isChanged у него не отменяли, то его нужно оставить true
          tempAccount.change();
          state.accountList[accountNumber] = tempAccount;
        } else {
          state.accountList[accountNumber] = tempAccount;
        }
        await repository.saveAccountListToSharedprefs(accountList: state.accountList);
        yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
      } on NoTriesLeftException {
        yield AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'Oops! No tries left, please try again later');
      } on NoAccountException {
        yield AccountListStateError(
            accountList: state.accountList, updater: state.updater, errorText: 'Account not found: ${accountListEvent.account.username}');
      } on ConnectionException {
        yield AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'Network error');
      }
    }

    //--------------- ОБНОВЛЯЕМ ВЕСЬ СПИСОК ---------------//
    if (accountListEvent is AccountListEventRefreshAll) {
      yield AccountListStateLoading(accountList: state.accountList, updater: state.updater);
      List<Account> accountList = state.accountList;
      for (Account currentAccount in accountList) {
        try {
          Account tempAccount = await repository.getAccountFromInternet(accountName: currentAccount.username);
          int accountNumber = state.accountList.indexOf(currentAccount);
          if (tempAccount.isPrivate != state.accountList[accountNumber].isPrivate || state.accountList[accountNumber].isChanged == true) {
            //ставим isChanged в true, если статус приватности изменился. А отключить его можно только по тапу (включается при изменении статуса, а отключается по тапу)
            //или если аккаунт уже менял статус приватности до этого обновления, но isChanged у него не отменяли, то его нужно оставить true
            tempAccount.change();
            state.accountList[accountNumber] = tempAccount;
          } else {
            state.accountList[accountNumber] = tempAccount;
          }
          await repository.saveAccountListToSharedprefs(accountList: state.accountList);
          state.updater = Updater(lastTimeUpdated: DateTime.now().microsecondsSinceEpoch, refreshPeriod: state.updater.refreshPeriod, isDark: state.updater.isDark);
          await repository.saveUpdater(updater: state.updater);
        } on NoTriesLeftException {
          yield AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'Oops! No tries left, please try again later');
          break;
        } on NoAccountException {
          yield AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'Account not found: ${currentAccount.username}');
        } on ConnectionException {
          yield AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'Network error');
          break;
        }
      }
      yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
    }

    //--------------- УБИРАЕМ ОТМЕТКУ С АККАУНТА ---------------//
    if (accountListEvent is AccountListEventUnCheck) {
      yield AccountListStateLoading(accountList: state.accountList, updater: state.updater);
      List<Account> accountList = state.accountList;
      int accountNumber = state.accountList.indexOf(accountListEvent.account);
      accountListEvent.account.isChanged = false;
      state.accountList[accountNumber] = accountListEvent.account;
      await repository.saveAccountListToSharedprefs(accountList: state.accountList);
      yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
    }

    //--------------- ВЫБИРАЕМ ПЕРИОД ОБНОВЛЕНИЯ ---------------//
    if (accountListEvent is AccountListEventSetPeriod) {
      state.updater = Updater(lastTimeUpdated: state.updater.lastTimeUpdated, refreshPeriod: accountListEvent.period!, isDark: state.updater.isDark);
      await repository.saveUpdater(updater: state.updater);
      yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
    }

    //--------------- ПЕРЕКЛЮЧАЕМ ТЕМУ ---------------//
    // if (accountListEvent is AccountListEventSetTheme) {
    //   state.updater = Updater(lastTimeUpdated: state.updater.lastTimeUpdated, refreshPeriod: state.updater.refreshPeriod, isDark: accountListEvent.isDark);
    //   await repository.saveUpdater(updater: state.updater);
    //   yield AccountListStateLoaded(accountList: state.accountList, updater: state.updater);
    // }
  }
}
