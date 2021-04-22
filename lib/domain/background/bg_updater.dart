import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/models/updater.dart';
import 'package:Instasnitch/data/repositories/repositiory.dart';
import 'package:workmanager/workmanager.dart';

import 'notification.dart';

//это класс синглтон для обновления информации в фоновом режиме
class BgUpdater {
  late int refreshPeriod;
  static final BgUpdater _instance = BgUpdater._privateConstructor();

  BgUpdater._privateConstructor();

  factory BgUpdater({required int refreshPeriod}) {
    _instance.refreshPeriod = refreshPeriod;
    return _instance;
  }

  void setRefreshPeriod(int refreshPeriod) {
    this.refreshPeriod = refreshPeriod;
  }

  static Future<List<Account>> updateAccounts() async {
    Repository repository = Repository();
    List<Account> oldAccountList = await repository.getAccountListFromSharedprefs();
    List<Account> updatedAccountList = []..addAll(oldAccountList); //клонирю список чтобы можно было его обновлять, не трогая оригинальный список
    List<Account> notificationAccountList = []; //создаем пустой список для уведомлений
    Updater updater = await repository.getUpdater();
    _instance.refreshPeriod = updater.refreshPeriod; //установил тот период обновления, который был выбран и сохранен в sharedprefs
    for (Account currentAccount in oldAccountList) {
      try {
        Account updatedAccount = await repository.getAccountFromInternet(accountName: currentAccount.username);
        int accountNumber = oldAccountList.indexOf(currentAccount);
        if (updatedAccount.isPrivate != oldAccountList[accountNumber].isPrivate || oldAccountList[accountNumber].isChanged == true) {
          //ставим isChanged в true, если статус приватности изменился. А отключить его можно только по тапу (включается при изменении статуса, а отключается по тапу)
          //или если аккаунт уже менял статус приватности до этого обновления, но isChanged у него не отменяли, то его нужно оставить true
          if (updatedAccount.isPrivate != oldAccountList[accountNumber].isPrivate) {
            notificationAccountList.add(updatedAccount);
          }
          updatedAccount.change();
          updatedAccountList[accountNumber] = updatedAccount;
        } else {
          updatedAccountList[accountNumber] = updatedAccount;
        }
        await repository.saveAccountListToSharedprefs(accountList: updatedAccountList);
        updater = Updater(refreshPeriod: updater.refreshPeriod, isDark: updater.isDark);
        await repository.saveUpdater(updater: updater);
      } on NoTriesLeftException {
        //если не осталось попыток для обновления, то прерываем цикл и не обновляем больше
        break;
      } on NoAccountException {} on ConnectionException {} //если аккаунт не найден, тогда просто перехоим к следущему, но обновление не прекращаем
    }
    return notificationAccountList;
  }
  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      List<Account> accountList = await BgUpdater.updateAccounts(); //обновляем в фоне данные аккаунтов
      print('accountList fetched in background: $accountList');
      String result;
      switch (accountList.length) {
        case 0:
          return Future.value(true);
        case 1:
          {
            result = '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'}';
            await LocalNotification.initializer();
            LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: result);
            return Future.value(true);
          }
        case 2:
          {
            result =
            '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'} and ${accountList[1].username} is ${accountList[1].isPrivate ? 'private now' : 'public now'}';
            await LocalNotification.initializer();
            LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: result);
            return Future.value(true);
          }
        default:
          {
            result =
            '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'} and ${accountList.length - 1} accounts changed their private status';
            await LocalNotification.initializer();
            LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: result);
            return Future.value(true);
          }
      }
    });
  }
}

class BgUpdaterStatic {
  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      List<Account> accountList = await BgUpdater.updateAccounts(); //обновляем в фоне данные аккаунтов
      print('accountList fetched in background: $accountList');
      String result;
      switch (accountList.length) {
        case 0:
          return Future.value(true);
        case 1:
          {
            result = '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'}';
            await LocalNotification.initializer();
            LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: result);
            return Future.value(true);
          }
        case 2:
          {
            result =
            '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'} and ${accountList[1].username} is ${accountList[1].isPrivate ? 'private now' : 'public now'}';
            await LocalNotification.initializer();
            LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: result);
            return Future.value(true);
          }
        default:
          {
            result =
            '${accountList[0].username} is ${accountList[0].isPrivate ? 'private now' : 'public now'} and ${accountList.length - 1} accounts changed their private status';
            await LocalNotification.initializer();
            LocalNotification.showOneTimeNotification(title: 'Instasnitch', text: result);
            return Future.value(true);
          }
      }
    });
  }
}
