import 'package:Instasnitch/data/models/updater.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountListBloc, AccountListState>(
      builder: (context, state) {
        final bool _isDark = state.updater.isDark;
        final int _groupValue = state.updater.refreshPeriod;
        return Scaffold(
          body: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: GestureDetector(
                              child: IconButton(
                                tooltip: 'Back',
                                splashRadius: 22,
                                splashColor: Colors.purple,
                                highlightColor: Colors.deepPurple,
                                icon: const Icon(Icons.arrow_back_rounded, size: 25),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 48.0),
                              alignment: Alignment.center,
                              height: 30,
                              color: Colors.white,
                              child: Text(
                                'Settings',
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 14.5),
                          //   child: Text('Theme', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.bold)),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Dark mode', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          //     Switch.adaptive(value: _isDark, onChanged: (value) {
                          //       BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetTheme(isDark: value));
                          //     }),
                          //   ],
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.5),
                            child: Text('Automatic refresh period',
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Never (off)', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.off),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('15 minutes', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.minutes15),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('20 minutes', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.minutes20),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('30 minutes', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.minutes30),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1 hour', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.hour1),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('2 hour', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.hour2),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('6 hours', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.hour6),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('12 hours', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.hour12),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('24 hours', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                              Radio(
                                  value: getPeriod(Period.hour24),
                                  groupValue: _groupValue,
                                  onChanged: (int? value) {
                                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value));
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
