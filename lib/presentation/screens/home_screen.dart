// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:lurkr/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:lurkr/presentation/screens/settings_screen.dart';
import 'package:lurkr/presentation/widgets/account_list/account_list.dart';
import 'package:lurkr/presentation/widgets/account_list/custom_scroll_behavoir.dart';
import 'package:lurkr/presentation/widgets/bottom_menu/bottom_menu.dart';
import 'package:lurkr/presentation/widgets/snackbar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('date_formatter'.tr());

    print('state: ${context.watch<AccountListBloc>().state}');
    print(
        'refresh period in state (minutes): ${context.watch<AccountListBloc>().state.updater.refreshPeriod / 60000000}');

    return Scaffold(
      body: BlocListener(
        // snackbar message
        bloc: BlocProvider.of<AccountListBloc>(context),
        listener: (BuildContext context, AccountListState state) {
          if (state is AccountListStateDownloaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(
                  text: state.snackbarText, color: Colors.green.shade600),
            );
          }
          if (state is AccountListStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(text: state.errorText, color: Colors.red),
            );
          }
        },
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: Stack(
            children: [
              Column(
                children: [
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            height: 20,
                            color: Colors.white,
                            child: Image.asset('assets/top_logo.png'),
                          ),
                          Container(
                            child: GestureDetector(
                              child: IconButton(
                                tooltip: 'hint_settings'.tr(),
                                splashRadius: 22,
                                splashColor: Colors.purple,
                                highlightColor: Colors.deepPurple,
                                icon: const Icon(Icons.settings, size: 25),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (settingsContext) =>
                                          BlocProvider.value(
                                        value: BlocProvider.of<AccountListBloc>(
                                            context),
                                        child: SettingsScreen(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: AccountList(formatter: formatter),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}

