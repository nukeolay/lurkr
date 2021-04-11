import 'dart:convert';

import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/providers/account_api.dart';
import 'package:Instasnitch/data/providers/account_list_local.dart';

class AccountRepository {
  List<Account> accountList = [];

  final AccountListLocal accountListLocal = AccountListLocal();
  final AccountApi accountApi = AccountApi();

  Future<Account> getAccountFromInternet({required String accountName}) async {
    final String apiAccountString = await accountApi.getAccount(accountName: accountName);
    List tempInstagramResponse;
    try {
      tempInstagramResponse = jsonDecode(apiAccountString)['users'] as List;
    } catch (e) {
      throw NoTriesLeftException();
    }
    if (tempInstagramResponse.length == 0) {
      throw NoAccountException();
    }
    for (Map<String, dynamic> element in tempInstagramResponse) {
      if (element['user']['username'] == accountName) {
        return Account.fromApi(element['user']);
      }
    }
    throw NoAccountException();
  }

  Future<Account?> getAccountFromSharedprefs({required String accountName}) async {
    //todo может быть такой метод мне и не нужен
    accountList = await getAccountListFromSharedprefs();
    for (Account element in accountList) {
      if (element.username == accountName)
        return element;
      else
        return null;
    }
  }

  Future<List<Account>> getAccountListFromSharedprefs() async {
    final String? accountListLocalString = await accountListLocal.getAccountListLocal();
    try {
      List<dynamic> tempList = jsonDecode(accountListLocalString!); //todo непонятно что за проверка '!'
      for (dynamic element in tempList) {
          accountList.add(Account.fromSharedPrefs(element));
      }
      return accountList;
    } catch (e) {
      return accountList;
    }
  }

  Future<void> saveAccountListToSharedprefs({required List<Account> accountList}) async {
    await accountListLocal.setAccountListLocal(accountList: jsonEncode(accountList));
  }

  static Account getDummyAccount({
      String userName = 'dummy',
      bool isPrivate = false,
      String pk = 'error',
      String fullName = 'error',
      bool isVerified = false,
      bool hasAnonymousProfilePicture = false,
      bool isNew = false}) {
    Uri profilePicUrl = Uri.http('', 'error');
    int lastTimeUpdated = 0;
    return Account(
        username: userName,
        profilePicUrl: profilePicUrl,
        isPrivate: isPrivate,
        pk: pk,
        fullName: fullName,
        isVerified: isVerified,
        hasAnonymousProfilePicture: hasAnonymousProfilePicture,
        isNew: isNew,
        lastTimeUpdated: lastTimeUpdated);
  }
}
