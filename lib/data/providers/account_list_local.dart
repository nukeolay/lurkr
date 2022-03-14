import 'package:shared_preferences/shared_preferences.dart';

class AccountListLocal {
  Future<String?> getAccountListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // to get updated data after background update
    String? accountList;
    accountList = prefs.getString('accountList');
    return accountList;
  }

  Future<void> setAccountListLocal({required String accountList}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountList', accountList);
  }
}