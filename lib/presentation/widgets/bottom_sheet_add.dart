import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetAdd extends StatefulWidget {
  //сделал StatefulWidget потому, что иначе textEditingController обнуляется при сворачивании клавиатуры при каждом build
  @override
  _BottomSheetAddState createState() => _BottomSheetAddState();
}

class _BottomSheetAddState extends State<BottomSheetAdd> {
  final TextEditingController _textFieldController = new TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10.0)),
          child: SizedBox(width: 40.0, height: 5.0),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: _textFieldController,
            autofocus: true,
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.name,
            onSubmitted: (_) {
              BlocProvider.of<AccountListBloc>(context).add(AccountListEventAdd(accountName: _textFieldController.value.text));
              _textFieldController.clear();
              Navigator.pop(context);
            },
            decoration: InputDecoration.collapsed(
              hintText: 'Enter account name',
            ),
          ),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
          child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child:
                    Text('Add account', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w400)),
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
