import 'package:Instasnitch/data/models/updater.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:Instasnitch/presentation/widgets/custom_scroll_behavoir.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';

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
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
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
                                  tooltip: 'button_back'.tr(),
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
                                  'title_settings'.tr(),
                                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 14.5),
                                  child: Text('title_battery_optimization'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.5),
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    //margin: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Icon(Icons.battery_charging_full_rounded, size: 30.0, color: Colors.white),
                                                SizedBox(width: 20.0),
                                                Text('button_battery_optimization'.tr(), style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Permission.ignoreBatteryOptimizations.request();
                                        }),
                                  ),
                                ),
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
                                  child: Text('title_refresh_period'.tr(),
                                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_off'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.off),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_15minutes'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.minutes15),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text('period_20minutes'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                //     Radio(
                                //         value: getPeriod(Period.minutes20),
                                //         groupValue: _groupValue,
                                //         onChanged: (int? value) {
                                //           BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                //         }),
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_30minutes'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.minutes30),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_1hour'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.hour1),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_2hour'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.hour2),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_6hours'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.hour6),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_12hours'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.hour12),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('period_24hours'.tr(), style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                                    Radio(
                                        value: getPeriod(Period.hour24),
                                        groupValue: _groupValue,
                                        onChanged: (int? value) {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventSetPeriod(period: value!));
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
