import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:Instasnitch/presentation/widgets/account_list/account_avatar.dart';
import 'package:Instasnitch/presentation/widgets/bottom_menu/bottom_sheet_edit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AccountList extends StatelessWidget {
  const AccountList({
    Key? key,
    required this.formatter,
  }) : super(key: key);

  final DateFormat formatter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountListBloc, AccountListState>(
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
        return RefreshIndicator(
          backgroundColor: Colors.purple,
          color: Colors.white,
          strokeWidth: 3.0,
          child: ListView.builder(
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
                                  account:
                                      tempLoadedAccount));
                        }
                      : null,
                  leading: AccountAvatar(
                      account: tempLoadedAccount),
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
          ),
          onRefresh: () async {
            BlocProvider.of<AccountListBloc>(context)
                .add(AccountListEventRefreshAll());
          },
        );
      },
    );
  }
}
