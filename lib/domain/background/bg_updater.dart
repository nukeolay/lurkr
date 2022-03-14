import 'package:lurkr/data/models/account.dart';
import 'package:lurkr/data/models/exceptions.dart';
import 'package:lurkr/data/models/updater.dart';
import 'package:lurkr/data/repositories/repositiory.dart';

// this class is used to update data in the background
class BgUpdater {
  late int refreshPeriod;
  static final BgUpdater _instance = BgUpdater._privateConstructor();

  BgUpdater._privateConstructor();

  factory BgUpdater({required int refreshPeriod}) {
    _instance.refreshPeriod = refreshPeriod;
    return _instance;
  }

  static Future<List<Account>> updateAccounts() async {
    Repository repository = Repository();
    List<Account> oldAccountList = await repository.getAccountListFromSharedprefs();
    List<Account> updatedAccountList = []..addAll(oldAccountList); // clone list to update it not updating the original one
    List<Account> notificationAccountList = []; // create empty list to store notification
    Updater updater = await repository.getUpdater();
    _instance.refreshPeriod = updater.refreshPeriod; // set update period that was stored in sharedprefs
    for (Account currentAccount in oldAccountList) {
      try {
        Account updatedAccount = await repository.getAccountFromInternet(accountName: currentAccount.username);
        int accountNumber = oldAccountList.indexOf(currentAccount);
        if (updatedAccount.isPrivate != oldAccountList[accountNumber].isPrivate || oldAccountList[accountNumber].isChanged == true) {
          //set isChanged to true, if privacy status has been changed.
          if (updatedAccount.isPrivate != oldAccountList[accountNumber].isPrivate) {
            notificationAccountList.add(updatedAccount);
          }
          updatedAccount.change();
          updatedAccountList[accountNumber] = updatedAccount;
        } else {
          updatedAccountList[accountNumber] = updatedAccount;
        }
        await repository.saveAccountListToSharedprefs(accountList: updatedAccountList);
        updater = Updater(refreshPeriod: updater.refreshPeriod, isDark: updater.isDark, isFirstTime: updater.isFirstTime);
        await repository.saveUpdater(updater: updater);
      } on NoTriesLeftException {
        break;
      } on NoAccountException {
      } on ConnectionException {}
    }
    return notificationAccountList;
  }
}
