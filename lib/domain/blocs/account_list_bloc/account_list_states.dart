import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/updater.dart';

abstract class AccountListState {
  List<Account> accountList;
  Updater updater;

  AccountListState({required this.accountList, required this.updater});
}

class AccountListStateStarting extends AccountListState {
  List<Account> accountList;
  Updater updater;

  AccountListStateStarting({required this.accountList, required this.updater}) : super(accountList: accountList, updater: updater);
}

class AccountListStateLoading extends AccountListState {
  List<Account> accountList;
  Updater updater;

  AccountListStateLoading({required this.accountList, required this.updater}) : super(accountList: accountList, updater: updater);
}

class AccountListStateLoaded extends AccountListState {
  List<Account> accountList;
  Updater updater;

  AccountListStateLoaded({required this.accountList, required this.updater}) : super(accountList: accountList, updater: updater);
}

class AccountListStateDownloaded extends AccountListState {
  List<Account> accountList;
  Updater updater;
  String snackbarText;

  AccountListStateDownloaded({required this.accountList, required this.updater, required this.snackbarText})
      : super(accountList: accountList, updater: updater);
}

class AccountListStateError extends AccountListState {
  List<Account> accountList;
  Updater updater;
  String errorText;

  AccountListStateError({required this.accountList, required this.updater, required this.errorText})
      : super(accountList: accountList, updater: updater);
}
