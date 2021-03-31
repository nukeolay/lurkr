import 'package:flutter/material.dart';
import 'package:instasnitch/data/api/model/api_account.dart';
import 'package:instasnitch/domain/exception/exception.dart';

import 'data/api/service/account_service.dart';

main() async {
  AccountService accountService = AccountService();
  List<String> accountList = [
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'kjnkj',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'kjnkj',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'kjnkj',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv',
    'kjnkj',
    'nukeolay',
    'klhnjknhkjhkhblkj',
    'to_be_ksusha',
    '1tv'
  ];
  for (String account in accountList) {
    try {
      ApiAccount tempAccount = await accountService.getAccount(accountName: account);
      print('${tempAccount.username}: ${tempAccount.isPrivate ? 'private' : 'public'}');
    } on NoAccountException catch(e) {
      print('$account: ${e.getErrorMessage()}');
    } on NoTriesLeftException catch(e) {
      print(e.getErrorMessage());
      break;
    } on ConnectionException catch(e) {
      print(e.getErrorMessage());
      break;
    }
  }
}
