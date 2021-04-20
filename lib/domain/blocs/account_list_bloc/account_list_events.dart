import 'package:Instasnitch/data/models/account.dart';

abstract class AccountListEvent {}

class AccountListEventStart extends AccountListEvent {
  AccountListEventStart();
}

class AccountListEventAdd extends AccountListEvent {
  String accountName;
  AccountListEventAdd({required this.accountName});
}

class AccountListEventDelete extends AccountListEvent {
  Account account;
  AccountListEventDelete({required this.account});
}

class AccountListEventDownload extends AccountListEvent {
  Account account;
  AccountListEventDownload({required this.account});
}

class AccountListEventRefresh extends AccountListEvent {
  Account account;
  AccountListEventRefresh({required this.account});
}

class AccountListEventRefreshAll extends AccountListEvent {}

class AccountListEventUnCheck extends AccountListEvent {
  Account account;
  AccountListEventUnCheck({required this.account});
}

class AccountListEventSetPeriod extends AccountListEvent {
  int? period;
  AccountListEventSetPeriod({required this.period});
}

class AccountListEventSetTheme extends AccountListEvent {
  bool isDark;
  AccountListEventSetTheme({required this.isDark});
}