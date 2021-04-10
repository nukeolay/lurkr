import 'package:flutter/material.dart';

class BottomSheetAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.email),
          title: Text('Send email'),
          onTap: () {
            print('Send email');
          },
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Call phone'),
          onTap: () {
            print('Call phone');
          },
        ),
      ],
    );;
  }
}
