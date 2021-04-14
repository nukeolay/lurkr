import 'dart:ui';

import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:Instasnitch/presentation/widgets/account_avatar.dart';
import 'package:Instasnitch/presentation/widgets/bottom_sheet_edit.dart';
import 'package:Instasnitch/presentation/widgets/rotating_icon.dart';
import 'package:Instasnitch/presentation/widgets/custom_scroll_behavoir.dart';
import 'package:Instasnitch/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_sheet_add.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('state: ${context.watch<AccountListBloc>().state}');
    final DateFormat formatter = DateFormat('dd.MM.yy HH:mm');
    return Scaffold(
      body: BlocListener(
        //тут выводим сообщения в snackbar в зависимости от state
        bloc: BlocProvider.of<AccountListBloc>(context),
        listener: (BuildContext context, AccountListState state) {
          if (state is AccountListStateDownloaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(text: state.snackbarText, color: Colors.green.shade600),
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
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 50.0, bottom: 5.0),
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
                              tooltip: 'Settings',
                              splashRadius: 22,
                              splashColor: Colors.purple,
                              highlightColor: Colors.deepPurple,
                              icon: const Icon(Icons.settings, size: 25),
                              onPressed: () {},
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: BlocBuilder<AccountListBloc, AccountListState>(
                        buildWhen: (previousState, state) {
                          bool isNeedToRebuild = state is AccountListStateLoaded;
                          return isNeedToRebuild;
                        },
                        builder: (context, state) {
                          if (state.accountList.isEmpty) {
                            return Center(
                              child: Text(
                                'давай @ добавляй',
                                style: TextStyle(color: Colors.purple, fontSize: 28.0, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                      ),
                                      builder: (BuildContext context) {
                                        return BottomSheetEdit(account: tempLoadedAccount);
                                      },
                                    );
                                  },
                                  onTap: tempLoadedAccount.isChanged
                                      ? () {
                                          BlocProvider.of<AccountListBloc>(context).add(AccountListEventUnCheck(account: tempLoadedAccount));
                                        }
                                      : null,
                                  leading: AccountAvatar(account: tempLoadedAccount),
                                  title: Text(state.accountList[index].username),
                                  subtitle: tempLoadedAccount.fullName ==
                                          'error' //todo посмотреть в каком случае может быть fullName error, может быть это удалить
                                      ? Text('error getting info', style: TextStyle(color: Colors.red))
                                      : tempLoadedAccount.lastTimeUpdated == 0
                                          ? Text('info does not loaded')
                                          : Text(
                                              'updated ${formatter.format(DateTime.fromMicrosecondsSinceEpoch(tempLoadedAccount.lastTimeUpdated))}'),
                                  trailing: Icon(
                                    state.accountList[index].isChanged ? Icons.new_releases_rounded : null,
                                    size: 30,
                                    color: state.accountList[index].isChanged
                                        ? state.accountList[index].isPrivate
                                            ? Colors.red
                                            : Colors.green
                                        : Colors.purple,
                                    semanticLabel: 'profile status changed',
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
        child: BlocBuilder<AccountListBloc, AccountListState>(builder: (context, state) {
          if (state is AccountListStateLoading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    tooltip: 'Refresh',
                    splashRadius: 22,
                    splashColor: Colors.purple,
                    highlightColor: Colors.deepPurple,
                    icon: RotatingRefreshIcon(),
                    onPressed: null),
                IconButton(
                  tooltip: 'Add account',
                  splashRadius: 22,
                  splashColor: Colors.purple,
                  highlightColor: Colors.deepPurple,
                  icon: const Icon(Icons.add_box_rounded, size: 30, color: Colors.grey),
                  onPressed: null,
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  tooltip: 'Refresh',
                  splashRadius: 22,
                  splashColor: Colors.purple,
                  highlightColor: Colors.deepPurple,
                  icon: Icon(Icons.refresh_rounded, size: 30),
                  onPressed: () {
                    BlocProvider.of<AccountListBloc>(context).add(AccountListEventRefreshAll());
                  }),
              IconButton(
                tooltip: 'Add account',
                splashRadius: 22,
                splashColor: Colors.purple,
                highlightColor: Colors.deepPurple,
                icon: const Icon(Icons.add_box_rounded, size: 30),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
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
