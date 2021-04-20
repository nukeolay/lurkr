import 'package:shared_preferences/shared_preferences.dart';

class AccountListLocal {
  Future<String?> getAccountListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload(); //добавил, чтобы получить актульные записи после обновления в фоне
    String? accountList;
    accountList = prefs.getString('accountList');
    return accountList;//todo когда получаю результат проверять на null
  }

  Future<void> setAccountListLocal({required String accountList}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountList', accountList);
  }
}