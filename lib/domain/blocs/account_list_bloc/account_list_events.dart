import 'package:Instasnitch/data/models/account.dart';

abstract class AccountListEvent {}

class AccountListEventStart extends AccountListEvent {
  AccountListEventStart();
}

class AccountListEventAdd extends AccountListEvent {
  String accountName;
  AccountListEventAdd({required this.accountName});
}

class AccountListEventEdit extends AccountListEvent {
  String accountName;
  AccountListEventEdit({required this.accountName});
}

class AccountListEventDelete extends AccountListEvent {
  String accountName;
  AccountListEventDelete({required this.accountName});
}

class AccountListEventDownload extends AccountListEvent {
  Account account;
  AccountListEventDownload({required this.account});
}

class AccountListEventRefresh extends AccountListEvent {
  String accountName;
  AccountListEventRefresh({required this.accountName});
}

class AccountListEventRefreshAll extends AccountListEvent {}