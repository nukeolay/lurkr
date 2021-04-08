import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountListBloc extends Bloc<AccountListEvent, AccountListState> {
  AccountListBloc(initialState) : super(LocationListStateLoading());

  @override
  Stream<AccountListState> mapEventToState(event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}