import 'dart:ui';
import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:Instasnitch/presentation/screens/settings_screen.dart';
import 'package:Instasnitch/presentation/widgets/account_avatar.dart';
import 'package:Instasnitch/presentation/widgets/bottom_sheet_edit.dart';
import 'package:Instasnitch/presentation/widgets/rotating_icon.dart';
import 'package:Instasnitch/presentation/widgets/custom_scroll_behavoir.dart';
import 'package:Instasnitch/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; //TODO убрал, чтобы проверить, достаточно ли easy_localization? или форматтер берется только из intl
import 'package:Instasnitch/presentation/widgets/bottom_sheet_add.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('date_formatter'.tr());

    print('state: ${context.watch<AccountListBloc>().state}');
    //print('updated on: ${formatter.format(DateTime.fromMicrosecondsSinceEpoch(context.watch<AccountListBloc>().state.updater.lastTimeUpdated))}');
    print(
        'refresh period in state (minutes): ${context.watch<AccountListBloc>().state.updater.refreshPeriod / 60000000}');
    //print('isDark: ${context.watch<AccountListBloc>().state.updater.isDark}');

    return Scaffold(
      body: BlocListener(
        //тут выводим сообщения в snackbar в зависимости от state
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
          //убираю подсветку границ при скролле
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
                            height: 30,
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
                      child: BlocBuilder<AccountListBloc, AccountListState>(
                        buildWhen: (previousState, state) {
                          bool isNeedToRebuild =
                              state is AccountListStateLoaded;
                          return isNeedToRebuild;
                        },
                        builder: (context, state) {
                          if (state.accountList.isEmpty) {
                            return Center(
                              child: Text(
                                'blank_text'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 28.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: state.accountList.length,
                            itemExtent: 90,
                            addAutomaticKeepAlives: true,
                            itemBuilder: (context, index) {
                              Account tempLoadedAccount;
                              tempLoadedAccount = state.accountList[index];
                              return Center(
                                child: ListTile(
                                  onLongPress: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0)),
                                      ),
                                      builder: (BuildContext context) {
                                        return BottomSheetEdit(
                                            account: tempLoadedAccount);
                                      },
                                    );
                                  },
                                  onTap: tempLoadedAccount.isChanged
                                      ? () {
                                          BlocProvider.of<AccountListBloc>(
                                                  context)
                                              .add(AccountListEventUnCheck(
                                                  account: tempLoadedAccount));
                                        }
                                      : null,
                                  leading:
                                      AccountAvatar(account: tempLoadedAccount),
                                  title:
                                      Text(state.accountList[index].username),
                                  subtitle: tempLoadedAccount.fullName ==
                                          'error' //TODO посмотреть в каком случае может быть fullName error, может быть это удалить
                                      ? Text('error_getting_info'.tr(),
                                          style: TextStyle(color: Colors.red))
                                      : tempLoadedAccount.lastTimeUpdated == 0
                                          ? Text('error_info_not_loaded'.tr())
                                          : Text('info_updated'.tr(args: [
                                              formatter.format(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      tempLoadedAccount
                                                          .lastTimeUpdated))
                                            ])),
                                  trailing: Icon(
                                    state.accountList[index].isChanged
                                        ? Icons.new_releases_rounded
                                        : null,
                                    size: 30,
                                    color: state.accountList[index].isChanged
                                        ? state.accountList[index].isPrivate
                                            ? Colors.red
                                            : Colors.green
                                        : Colors.purple,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: BlocBuilder<AccountListBloc, AccountListState>(
            builder: (context, state) {
          if (state is AccountListStateLoading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    tooltip: 'button_refresh'.tr(),
                    splashRadius: 22,
                    splashColor: Colors.purple,
                    highlightColor: Colors.deepPurple,
                    icon: RotatingRefreshIcon(),
                    onPressed: null),
                IconButton(
                  tooltip: 'button_add'.tr(),
                  splashRadius: 22,
                  splashColor: Colors.purple,
                  highlightColor: Colors.deepPurple,
                  icon: const Icon(Icons.add_box_rounded,
                      size: 30, color: Colors.grey),
                  onPressed: null,
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  tooltip: 'button_refresh'.tr(),
                  splashRadius: 22,
                  splashColor: Colors.purple,
                  highlightColor: Colors.deepPurple,
                  icon: Icon(Icons.refresh_rounded, size: 30),
                  onPressed: () {
                    BlocProvider.of<AccountListBloc>(context)
                        .add(AccountListEventRefreshAll());
                  }),
              IconButton(
                tooltip: 'button_add'.tr(),
                splashRadius: 22,
                splashColor: Colors.purple,
                highlightColor: Colors.deepPurple,
                icon: const Icon(Icons.add_box_rounded, size: 30),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                    builder: (BuildContext context) {
                      return BottomSheetAdd();
                    },
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
