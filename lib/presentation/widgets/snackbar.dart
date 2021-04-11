import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  final String text;
  final Color color;

  CustomSnackbar({required this.text, required this.color})
      : super(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: color,
            content: Text(text));
}
