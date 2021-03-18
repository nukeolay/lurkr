import 'package:flutter/material.dart';

import 'domain/model/account.dart';

main() async {
  List<String> accountList = [
    'nukeolay',
    'to_be_ksusha',
    'kurushina',
    'morgen_shtern',
    '1tv',
    'lkjhmlkjhlkhlljfydyt'
  ];
  for (String account in accountList) {
    try {
      print(await getAccount(account));
    } catch (e) {
      print('name: $account, no such account');
    }
  }
}
