import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.black,
      secondaryHeaderColor: Colors.white,
      fontFamily: 'Montserrat',
      errorColor: Colors.red,
      cardColor: Colors.white,
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.blueGrey[50],
      accentColor: Colors.purple,
      scaffoldBackgroundColor: Colors.grey[900],
      primaryColorLight: Colors.blueGrey[50],
      primaryColorDark: Colors.white,
      secondaryHeaderColor: Colors.white,
      fontFamily: 'Montserrat',
      errorColor: Colors.red[900],
      cardColor: Colors.grey[700],
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.grey[700],
      ),
    );
  }
}
