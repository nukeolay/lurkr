import 'package:flutter_bloc/flutter_bloc.dart';

import 'connection_events.dart';
import 'connection_states.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc() : super(ConnectingState());

  @override
  Stream<ConnectionState> mapEventToState(event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
