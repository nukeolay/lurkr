import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          height: 50,
          //alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 34),
          //padding: const EdgeInsets.only(left: 5),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_rounded, color: Colors.grey[600], size: 24,),
                  SizedBox(width: 10.0),
                  Text(account.username,
                      style: TextStyle(color: Colors.grey[600], fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
        (account.hasAnonymousProfilePicture || account.savedProfilePic.toString() == '')
            ? SizedBox()
            : Container(
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10.0)),
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
                            Icon(Icons.download_rounded, size: 30.0, color: Colors.white),
                            SizedBox(width: 20.0),
                            Text('Save avatar picture',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<AccountListBloc>(context).add(AccountListEventDownload(account: account)); //todo написать
                      Navigator.pop(context);
                    }),
              ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 5.0, bottom: 10.0, left: 10.0, right: 10.0),
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
                      Icon(Icons.delete_outline_rounded, size: 30.0, color: Colors.white),
                      SizedBox(width: 20.0),
                      Text('Delete', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                BlocProvider.of<AccountListBloc>(context).add(AccountListEventDelete(accountName: account.username));
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}
