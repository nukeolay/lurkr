import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  final String text;
  final Color color;

  CustomSnackbar({required this.text, required this.color})
      : super(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: color,
            content: Text(text));
}
