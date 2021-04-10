import 'package:Instasnitch/data/models/account.dart';

abstract class AccountListState {
  List<Account> accountList;

  AccountListState({required this.accountList});
}

class AccountListStateStarting extends AccountListState {
  List<Account> accountList;

  AccountListStateStarting({required this.accountList}) : super(accountList: accountList);
}

class AccountListStateLoading extends AccountListState {
  List<Account> accountList;

  AccountListStateLoading({required this.accountList}) : super(accountList: accountList);
}

class AccountListStateLoaded extends AccountListState {
  List<Account> accountList;

  AccountListStateLoaded({required this.accountList}) : super(accountList: accountList);
}

class AccountListStateExists extends AccountListState {
  List<Account> accountList;

  AccountListStateExists({required this.accountList}) : super(accountList: accountList);
}

class AccountListStateNoTriesLeft extends AccountListState {
  List<Account> accountList;

  AccountListStateNoTriesLeft({required this.accountList}) : super(accountList: accountList);
}

class AccountListStateNotFound extends AccountListState {
  List<Account> accountList;

  AccountListStateNotFound({required this.accountList}) : super(accountList: accountList);
}
