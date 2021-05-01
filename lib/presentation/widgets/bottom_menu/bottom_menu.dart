import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_states.dart';
import 'package:Instasnitch/presentation/widgets/bottom_menu/bottom_sheet_add.dart';
import 'package:Instasnitch/presentation/widgets/bottom_menu/bottom_sheet_download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      child: BlocBuilder<AccountListBloc, AccountListState>(
          builder: (context, state) {
        if (state is AccountListStateLoading) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                tooltip: 'button_download'.tr(),
                splashRadius: 22,
                splashColor: Colors.purple,
                highlightColor: Colors.deepPurple,
                icon: const Icon(Icons.save_alt_rounded,
                    size: 30, color: Colors.grey),
                onPressed: null,
              ),
              IconButton(
                tooltip: 'button_add'.tr(),
                splashRadius: 22,
                splashColor: Colors.purple,
                highlightColor: Colors.deepPurple,
                icon: const Icon(Icons.add_box_outlined,
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
                tooltip: 'button_download'.tr(),
                splashRadius: 22,
                splashColor: Colors.purple,
                highlightColor: Colors.deepPurple,
                icon: Icon(Icons.save_alt_rounded, size: 30),
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
                    return BottomSheetDownload();
                  },
                );
              }),
            IconButton(
              tooltip: 'button_add'.tr(),
              splashRadius: 22,
              splashColor: Colors.purple,
              highlightColor: Colors.deepPurple,
              icon: const Icon(Icons.add_box_outlined, size: 30),
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
    );
  }
}
