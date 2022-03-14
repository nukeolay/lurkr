import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:lurkr/data/providers/api_utils.dart';
import 'package:lurkr/data/models/account.dart';
import 'package:lurkr/data/models/exceptions.dart';
import 'package:lurkr/data/models/updater.dart';
import 'package:lurkr/data/repositories/repositiory.dart';
import 'package:lurkr/domain/background/bg_updater.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_states.dart';

class AccountListBloc extends Bloc<AccountListEvent, AccountListState> {
  Repository repository = Repository();

  AccountListBloc()
      : super(
          AccountListStateStarting(
            accountList: [],
            updater: Updater(refreshPeriod: 0, isDark: false, isFirstTime: true),
          ),
        ) {
    //--------------- LAUNCHING ---------------//
    on<AccountListEventStart>((accountListEvent, emit) async {
      List<Account> tempAccountList = await repository.getAccountListFromSharedprefs();
      Updater updater = await repository.getUpdater();
      await Future.delayed(Duration(seconds: 1));
      emit(AccountListStateLoaded(accountList: tempAccountList, updater: updater));
    });

    //--------------- ACCOUNT ADD ---------------//
    on<AccountListEventAdd>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      // check if account already added
      if (state.accountList.contains(Repository.getDummyAccount(userName: accountListEvent.accountName))) {
        emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_account_exists'.tr()));
      }
      // if added 5 or more accounts show error
      else if (state.accountList.length >= 5) {
        emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_max_accounts'.tr()));
      } else {
        try {
          Account tempAccount = await repository.getAccountFromInternet(accountName: accountListEvent.accountName);
          state.accountList.insert(0, tempAccount);
          await repository.saveAccountListToSharedprefs(accountList: state.accountList);
          state.updater = Updater(refreshPeriod: state.updater.refreshPeriod, isDark: state.updater.isDark, isFirstTime: state.updater.isFirstTime);
          await repository.saveUpdater(updater: state.updater);
          emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
        } on NoTriesLeftException {
          state.accountList.insert(0, Repository.getDummyAccount(userName: accountListEvent.accountName, fullName: 'error_info_not_loaded'.tr()));
          await repository.saveAccountListToSharedprefs(accountList: state.accountList);
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_no_tries_left'.tr()));
        } on NoAccountException {
          emit(AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'error_account_not_found'.tr(args: [accountListEvent.accountName])));
        } on ConnectionException {
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_network'.tr()));
        } on ConnectionTimeoutException {
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_connection_timeout'.tr()));
        }
      }
    });

    //--------------- ACCOUNT REMOVE ---------------//
    on<AccountListEventDelete>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      state.accountList.remove(accountListEvent.account);
      await repository.saveAccountListToSharedprefs(accountList: state.accountList);
      emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
    });

    //--------------- SAVE AVATAR ---------------//
    on<AccountListEventDownloadHdPic>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      bool isPermissionGranted = await Permission.storage.status.isGranted;
      if (isPermissionGranted) {
        try {
          // try to download avatar in HD
          String hdPicUri = await repository.getHdPicUri(accountName: accountListEvent.account.username);
          String stringImage = await ImageConverter.convertUriImageToString(hdPicUri);
          await ImageGallerySaver.saveImage(Uint8List.fromList(stringImage.codeUnits),
              quality: 100, name: 'lurkr_avatar_hd_${accountListEvent.account.username}');
          emit(AccountListStateDownloaded(accountList: state.accountList, updater: state.updater, snackbarText: 'info_file_saved'.tr()));
        } catch (e) {
          // if cant dwonload in HD then download it with low quality
          Uint8List imageData = Uint8List.fromList(accountListEvent.account.savedProfilePic.codeUnits);
          dynamic result =
              await ImageGallerySaver.saveImage(Uint8List.fromList(imageData), quality: 100, name: 'lurkr_avatar_${accountListEvent.account.username}');
          if (result['error'] != null) {
            emit(AccountListStateError(
                accountList: state.accountList, updater: state.updater, errorText: 'error_image_not_saved'.tr(args: [result['error'].toString()])));
          } else {
            emit(AccountListStateDownloaded(accountList: state.accountList, updater: state.updater, snackbarText: 'info_file_saved'.tr()));
          }
        }
      } else {
        PermissionStatus permissionStatus = await Permission.storage.request();
        if (permissionStatus.isGranted) {
          add(AccountListEventDownloadHdPic(account: accountListEvent.account));
        } else {
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_permission_storage'.tr()));
        }
      }
    });

    //--------------- MEDIA DOWNLOADING ---------------//
    on<AccountListEventDownloadMedia>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      if (accountListEvent.mediaRawUrl.isEmpty) {
        // if user entered nothing
        emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_empty_input'.tr()));
      } else {
        bool isPermissionGranted = await Permission.storage.status.isGranted;
        if (isPermissionGranted) {
          try {
            List<String> uriList = await repository.getAllMediaUri(mediaRawUrl: accountListEvent.mediaRawUrl);
            var appDocDir = await getTemporaryDirectory();
            for (String mediaUri in uriList) {
              String savePath = appDocDir.path + 'lurkr_${DateTime.now().millisecondsSinceEpoch.toString()}.${mediaUri.contains('.mp4') ? 'mp4' : 'jpg'}';
              await repository.downloadMedia(mediaUri, savePath);
              await ImageGallerySaver.saveFile(savePath);
            }
            emit(AccountListStateDownloaded(accountList: state.accountList, updater: state.updater, snackbarText: 'info_file_saved'.tr()));
          } on NoTriesLeftException {
            emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_no_tries_left'.tr()));
          } on ConnectionException {
            emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_network'.tr()));
          } on ConnectionTimeoutException {
            emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_connection_timeout'.tr()));
          }
        } else {
          PermissionStatus permissionStatus = await Permission.storage.request();
          if (permissionStatus.isGranted) {
            add(AccountListEventDownloadMedia(mediaRawUrl: accountListEvent.mediaRawUrl));
          } else {
            emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_permission_storage'.tr()));
          }
        }
      }
    });

    //--------------- ACCOUNT UPDATE ---------------//
    on<AccountListEventRefresh>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      try {
        Account tempAccount = await repository.getAccountFromInternet(accountName: accountListEvent.account.username);
        int accountNumber = state.accountList.indexOf(accountListEvent.account);
        if (tempAccount.isPrivate != state.accountList[accountNumber].isPrivate || state.accountList[accountNumber].isChanged == true) {
          // set isChanged to true, if privacy status has been changed
          tempAccount.change();
          state.accountList[accountNumber] = tempAccount;
        } else {
          state.accountList[accountNumber] = tempAccount;
        }
        await repository.saveAccountListToSharedprefs(accountList: state.accountList);
        emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
      } on NoTriesLeftException {
        emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_no_tries_left'.tr()));
      } on NoAccountException {
        emit(AccountListStateError(
            accountList: state.accountList, updater: state.updater, errorText: 'error_account_not_found'.tr(args: [accountListEvent.account.username])));
      } on ConnectionException {
        emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_network'.tr()));
      } on ConnectionTimeoutException {
        emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_connection_timeout'.tr()));
      }
    });

    //--------------- UPDATE ACCOUNT LIST ---------------//
    on<AccountListEventRefreshAll>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      List<Account> accountList = state.accountList;
      for (Account currentAccount in accountList) {
        try {
          Account tempAccount = await repository.getAccountFromInternet(accountName: currentAccount.username);
          int accountNumber = state.accountList.indexOf(currentAccount);
          if (tempAccount.isPrivate != state.accountList[accountNumber].isPrivate || state.accountList[accountNumber].isChanged == true) {
            // set isChanged to true, if privacy status has been changed
            tempAccount.change();
            state.accountList[accountNumber] = tempAccount;
          } else {
            state.accountList[accountNumber] = tempAccount;
          }
          await repository.saveAccountListToSharedprefs(accountList: state.accountList);
          state.updater = Updater(refreshPeriod: state.updater.refreshPeriod, isDark: state.updater.isDark, isFirstTime: state.updater.isFirstTime);
          await repository.saveUpdater(updater: state.updater);
        } on NoTriesLeftException {
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_no_tries_left'.tr()));
          break;
        } on NoAccountException {
          emit(AccountListStateError(
              accountList: state.accountList, updater: state.updater, errorText: 'error_account_not_found'.tr(args: [currentAccount.username])));
        } on ConnectionException {
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_network'.tr()));
          break;
        } on ConnectionTimeoutException {
          emit(AccountListStateError(accountList: state.accountList, updater: state.updater, errorText: 'error_connection_timeout'.tr()));
        }
      }
      emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
    });

    //--------------- REMOVE ACCOUNT CHECK ---------------//
    on<AccountListEventUnCheck>((accountListEvent, emit) async {
      emit(AccountListStateLoading(accountList: state.accountList, updater: state.updater));
      int accountNumber = state.accountList.indexOf(accountListEvent.account);
      accountListEvent.account.isChanged = false;
      state.accountList[accountNumber] = accountListEvent.account;
      await repository.saveAccountListToSharedprefs(accountList: state.accountList);
      emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
    });

    //--------------- UPDATE ACCOUNT ---------------//
    on<AccountListEventSetPeriod>((accountListEvent, emit) async {
      state.updater = Updater(refreshPeriod: accountListEvent.period, isDark: state.updater.isDark, isFirstTime: state.updater.isFirstTime);
      await repository.saveUpdater(updater: state.updater);
      BgUpdater(refreshPeriod: accountListEvent.period);
      await Workmanager().cancelAll();
      if (accountListEvent.period > 0) {
        await Workmanager().registerPeriodicTask('lurkr_task', 'lurkr_task',
            inputData: {}, frequency: Duration(microseconds: accountListEvent.period), initialDelay: Duration(microseconds: accountListEvent.period));
      }
      emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
    });

    //--------------- TUTORIAL FINISH ---------------//
    on<AccountListEventInstructionOk>((accountListEvent, emit) async {
      state.updater = Updater(refreshPeriod: state.updater.refreshPeriod, isDark: state.updater.isDark, isFirstTime: false);
      await repository.saveUpdater(updater: state.updater);
      emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
    });

    //--------------- CHANGE THEME ---------------//
    on<AccountListEventSetTheme>((accountListEvent, emit) async {
      state.updater = Updater(refreshPeriod: state.updater.refreshPeriod, isDark: accountListEvent.isDark, isFirstTime: state.updater.isFirstTime);
      await repository.saveUpdater(updater: state.updater);
      emit(AccountListStateLoaded(accountList: state.accountList, updater: state.updater));
    });
  }
}
