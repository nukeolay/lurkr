import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lurkr/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_events.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AccountListBloc>(context).add(AccountListEventStart());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              color: Colors.white,
              child: Image.asset('assets/splash_logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
