import 'dart:io';
import 'package:lurkr/data/models/account.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:lurkr/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomSheetEdit extends StatelessWidget {
  final Account account;

  BottomSheetEdit({required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10.0)),
          child: SizedBox(width: 40.0, height: 5.0),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(
              top: 5.0, bottom: 0.0, left: 0.0, right: 34.0),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  SizedBox(width: 10.0),
                  Text(account.username,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
        (account.hasAnonymousProfilePicture ||
                account.savedProfilePic.toString() == '')
            ? SizedBox()
            : Container(
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10.0)),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Center(
                        child: Row(
                          children: [
                            Icon(Icons.download_rounded,
                                size: 30.0, color: Colors.white),
                            SizedBox(width: 20.0),
                            Text('button_download_avatar'.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<AccountListBloc>(context)
                          .add(AccountListEventDownloadHdPic(account: account));
                      Navigator.pop(context);
                    }),
              ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10.0)),
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
                      Icon(Icons.refresh_rounded,
                          size: 30.0, color: Colors.white),
                      SizedBox(width: 20.0),
                      Text('button_refresh'.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                BlocProvider.of<AccountListBloc>(context)
                    .add(AccountListEventRefresh(account: account));
                Navigator.pop(context);
              }),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: 5.0,
              bottom: Platform.isIOS ? 50.0 : 10.0,
              left: 10.0,
              right: 10.0),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
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
                      Icon(Icons.delete_outline_rounded,
                          size: 30.0, color: Colors.white),
                      SizedBox(width: 20.0),
                      Text('button_delete'.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                BlocProvider.of<AccountListBloc>(context)
                    .add(AccountListEventDelete(account: account));
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}
