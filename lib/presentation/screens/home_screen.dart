import 'dart:ui';

import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:Instasnitch/presentation/widgets/account_avatar.dart';
import 'package:Instasnitch/presentation/widgets/bottom_sheet_edit.dart';
import 'package:Instasnitch/presentation/widgets/rotating_icon.dart';
import 'package:Instasnitch/presentation/widgets/custom_scroll_behavoir.dart';
import 'package:Instasnitch/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bottom_sheet_add.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('state: ${context.watch<AccountListBloc>().state}');
    print(context.watch<AccountListBloc>().state.accountList);
    return Scaffold(
      body: BlocListener(
        bloc: BlocProvider.of<AccountListBloc>(context),
        listener: (BuildContext context, AccountListState state) {
          if (state is AccountListStateExists) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(text: 'Account already added', color: Colors.red),
            );
          }
          if (state is AccountListStateNoTriesLeft) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(text: 'Oops! No tries left, please try again later', color: Colors.red),
            );
          }
          if (state is AccountListStateNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackbar(text: 'Account not found', color: Colors.red),
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
                                    leading: AccountAvatar(account: tempLoadedAccount),
                                    title: Text(state.accountList[index].username),
                                    subtitle: tempLoadedAccount.fullName == 'error'
                                        ? Text('error getting info', style: TextStyle(color: Colors.red))
                                        : Text(tempLoadedAccount.fullName)
                                    // trailing: Icon(
                                    //   Icons.lock_outline_rounded,
                                    //   size: 30,
                                    // ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            BlocBuilder<AccountListBloc, AccountListState>(builder: (context, state) {
              if (state is AccountListStateLoading) {
                return IconButton(
                    tooltip: 'Refresh',
                    splashRadius: 22,
                    splashColor: Colors.purple,
                    highlightColor: Colors.deepPurple,
                    icon: RotatingRefreshIcon(),
                    onPressed: () {});
              }
              return IconButton(
                  tooltip: 'Refresh',
                  splashRadius: 22,
                  splashColor: Colors.purple,
                  highlightColor: Colors.deepPurple,
                  icon: Icon(Icons.refresh_rounded, size: 30),
                  onPressed: () {});
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
            )
          ],
        ),
      ),
    );
  }
}