import 'package:shared_preferences/shared_preferences.dart';

class AccountListLocal {
  Future<String?> getAccountListLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountList;
    accountList = prefs.getString('accountList');
    return accountList;//todo когда получаю результат проверять на null
  }

  void setAccountListLocal({required String accountList}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountList', accountList);
  }
}