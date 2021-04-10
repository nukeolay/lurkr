import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/data/models/exceptions.dart';
import 'package:Instasnitch/data/repositories/account_repositiory.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountListBloc extends Bloc<AccountListEvent, AccountListState> {
  AccountRepository accountRepository = AccountRepository();

  AccountListBloc() : super(AccountListStateStarting(accountList: []));

  @override
  Stream<AccountListState> mapEventToState(AccountListEvent accountListEvent) async* {
    //---------------ЗАПУСКАЕМ ПРИЛОЖЕНИЕ---------------//
    if (accountListEvent is AccountListEventStart) {
      List<Account> tempAccountList = await accountRepository.getAccountListFromSharedprefs();
      yield AccountListStateLoaded(accountList: tempAccountList);
    }

    //---------------ДОБАВЛЯЕМ АККАУНТ---------------//
    if (accountListEvent is AccountListEventAdd) {
      yield AccountListStateLoading(accountList: state.accountList);
      //проверяем нет ли уже такого аккаунта в списке, для этого в классе Account переопределил опреатор '=='
      if (state.accountList.contains(AccountRepository.getDummyAccount(userName: accountListEvent.accountName))) {
        yield AccountListStateExists(accountList: state.accountList);
      } else {
        try {
          Account tempAccount = await accountRepository.getAccountFromInternet(accountName: accountListEvent.accountName);
          state.accountList.insert(0, tempAccount);
          accountRepository.saveAccountListToSharedprefs(accountList: state.accountList);
          yield AccountListStateLoaded(accountList: state.accountList);
        } on NoTriesLeftException {
          state.accountList.insert(0, AccountRepository.getDummyAccount(userName: accountListEvent.accountName, fullName: 'not updated'));
          yield AccountListStateNoTriesLeft(accountList: state.accountList);
        } on NoAccountException {
          yield AccountListStateNotFound(accountList: state.accountList);
        }
      }
    }
  }
}
