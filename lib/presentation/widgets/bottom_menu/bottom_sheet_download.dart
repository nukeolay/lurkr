import 'dart:io';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_bloc.dart';
import 'package:Instasnitch/domain/blocs/account_list_bloc/account_list_events.dart';
import 'package:Instasnitch/presentation/screens/download_instruction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomSheetDownload extends StatefulWidget {
  //сделал StatefulWidget потому, что иначе textEditingController обнуляется при сворачивании клавиатуры при каждом build
  @override
  _BottomSheetDownloadState createState() => _BottomSheetDownloadState();
}

class _BottomSheetDownloadState extends State<BottomSheetDownload> {
  final TextEditingController _textFieldController =
      new TextEditingController();

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
          decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(10.0)),
          child: SizedBox(width: 40.0, height: 5.0),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _textFieldController,
                  autofocus: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.text,
                  onSubmitted: (_) {
                    BlocProvider.of<AccountListBloc>(context).add(
                        AccountListEventAdd(
                            accountName: _textFieldController.value.text));
                    _textFieldController.clear();
                    Navigator.pop(context);
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'hint_enter_download_url'.tr(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 0.0, bottom: 0.0, left: 0.0, right: 20.0),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'button_help_download'.tr(),
                icon: const Icon(Icons.help_outline_rounded,
                    size: 40, color: Colors.green),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DownloadInstructionScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(10)),
          child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text('button_download'.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400)),
              ),
              onPressed: () {
                BlocProvider.of<AccountListBloc>(context).add(
                    AccountListEventAdd(
                        accountName: _textFieldController.value.text));
                _textFieldController.clear();
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}
