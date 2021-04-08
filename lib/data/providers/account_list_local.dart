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

// void setAccountListLocal(ApiSusaninData apiSusaninData) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString("lastTimeUpdated", int.parse(apiSusaninData.selectedLocationPointId));
//   await prefs.setInt("savedLocationCounter", int.parse(apiSusaninData.locationCounter));
//   await prefs.setBool("savedIsDarkTheme", apiSusaninData.isDarkTheme == "true" ? true : false);
//   await prefs.setBool("savedIsFirstTime", apiSusaninData.isFirstTime == "true" ? true : false);
//   await prefs.setString("savedLocationStorage", apiSusaninData.locationList);
// }
// }
