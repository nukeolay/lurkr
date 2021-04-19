import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/models/updater.dart';
import 'package:Instasnitch/data/repositories/repositiory.dart';

class BgUpdater {
  static final BgUpdater _instance = BgUpdater._privateConstructor();
  int refreshPeriod = 900000000; //todo перед релизом исправить на 30 минут

  BgUpdater._privateConstructor();

  factory BgUpdater() {
    return _instance;
  }

  void setRefreshPeriod(int refreshPeriod) {
    this.refreshPeriod = refreshPeriod;
  }

  static Future<List<Account>> updateAccounts() async {
    Repository repository = Repository();
    List<Account> oldAccountList = await repository.getAccountListFromSharedprefs();
    List<Account> updatedAccountList = await repository.getAccountListFromSharedprefs();
    List<Account> notificationAccountList = [];
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
        updater = Updater(lastTimeUpdated: DateTime.now().microsecondsSinceEpoch, refreshPeriod: updater.refreshPeriod, isDark: updater.isDark);
        await repository.saveUpdater(updater: updater);
      } on NoTriesLeftException {
        break;
      } on NoAccountException {} on ConnectionException {
        break;
      }
    }
    return notificationAccountList;
  }
}
