import 'dart:async';
import 'dart:typed_data';

import 'package:Instasnitch/data/models/account.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
        (account.hasAnonymousProfilePicture || account.profilePicUrl.toString() == 'error')
            ? SizedBox()
            : Container(
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
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
                            Icon(Icons.download_rounded, size: 30.0, color: Colors.white),
                            SizedBox(width: 20.0),
                            Text('Save avatar picture',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      // _getHttp() async {
                      //   var response = await Dio().get(
                      //       "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
                      //       options: Options(responseType: ResponseType.bytes));
                      //   final result = await ImageGallerySaver.saveImage(
                      //       Uint8List.fromList(response.data),
                      //       quality: 60,
                      //       name: "hello");
                      //   print(result);
                      //   _toastInfo("$result");
                      // }
                      Navigator.pop(context);
                    }),
              ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
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
