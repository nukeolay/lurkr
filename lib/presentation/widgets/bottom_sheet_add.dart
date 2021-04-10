import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textFieldController = new TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: _textFieldController,
            autofocus: true,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.name,
            decoration: InputDecoration.collapsed(
              hintText: 'Enter account name',
            ),
          ),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
          child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text('Add account', style: TextStyle(color: Colors.white)),
              ),
              onPressed: () {
                BlocProvider.of<AccountListBloc>(context).add(AccountListEventAdd(accountName: _textFieldController.value.text));
                _textFieldController.clear();
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}
