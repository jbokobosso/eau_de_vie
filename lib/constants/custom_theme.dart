import 'package:flutter/material.dart';

class CustomTheme {

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        background: Colors.white,
        primary: Color.fromRGBO(0, 146, 202, 1),
        primaryVariant: Color.fromRGBO(86, 0, 209, 1),
        secondary: Color.fromRGBO(61, 194, 255, 1),
        secondaryVariant: Color.fromRGBO(54, 171, 224, 1),
        onBackground: Colors.white,
        brightness: Brightness.light,
        error: Colors.red,
        onError: Colors.red,
        onSecondary: Colors.white,
        onPrimary: Colors.white,
        surface: Colors.grey,
        onSurface: Colors.grey,

      ),
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          buttonColor: Colors.blue,
          disabledColor: Colors.grey,
          textTheme: ButtonTextTheme.primary
      ),
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),
          subtitle2: TextStyle(fontSize: 10.0, color: Color.fromRGBO(29, 53, 61, 1), fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 25.0, color: Color.fromRGBO(100, 113, 150, 1)),
          bodyText2: TextStyle(fontSize: 12.0, color: Color.fromRGBO(100, 113, 150, 1))
      ),
      fontFamily: 'DAYROM',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        background: Colors.black45,
        primary: Color(0x00f88a0f),
        primaryVariant: Color(0x00CE4C22),
        secondary: Color(0x00214bbe),
        secondaryVariant: Color(0x0017A2B8),
        onBackground: Colors.white,
        brightness: Brightness.light,
        error: Colors.red,
        onError: Colors.red,
        onSecondary: Color(0x00214bbe),
        onPrimary: Color(0x00f88a0f),
        surface: Colors.grey,
        onSurface: Colors.grey,

      ),
      buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          buttonColor: Colors.blue,
          disabledColor: Colors.grey,
          textTheme: ButtonTextTheme.primary
      ),
      fontFamily: 'Montserrat',
    );
  }

}