import 'package:lurkr/data/models/account.dart';
import 'package:lurkr/data/models/exceptions.dart';
import 'package:lurkr/data/models/updater.dart';
import 'package:lurkr/data/repositories/repositiory.dart';

//это класс синглтон для обновления информации в фоновом режиме
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
    List<Account> updatedAccountList = []..addAll(oldAccountList); //клонирю список чтобы можно было его обновлять, не трогая оригинальный список
    List<Account> notificationAccountList = []; //создаем пустой список для уведомлений
    Updater updater = await repository.getUpdater(); //TODO разобраться зачем это делать
    _instance.refreshPeriod = updater.refreshPeriod; //установил тот период обновления, который был выбран и сохранен в sharedprefs //todo разобраться зачем это делать
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
        updater = Updater(refreshPeriod: updater.refreshPeriod, isDark: updater.isDark, isFirstTime: updater.isFirstTime); //TODO разобраться зачем это делать
        await repository.saveUpdater(updater: updater); //TODO разобраться зачем это делать
      } on NoTriesLeftException {
        //если не осталось попыток для обновления, то прерываем цикл и не обновляем больше
        break;
      } on NoAccountException {} on ConnectionException {} //если аккаунт не найден, тогда просто перехоим к следущему, но обновление не прекращаем
    }
    return notificationAccountList;
  }
}
