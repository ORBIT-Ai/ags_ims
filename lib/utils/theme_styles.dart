// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  Color primaryColor = Color(0xff00274D);
  Color accent = Color(0xffFF8088);

  static ThemeData themeData({
    BuildContext context,
  }) {
    Color primary;
    Color accent;
    Color primaryDark;
    Color buttonColorLight;

    primary = Color(0xff00274D);
    accent = Color(0xffFF8088);
    primaryDark = Color(0xff000D1A);
    buttonColorLight = Colors.blueAccent[100];

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      accentColor: accent,
      primaryColorDark: primaryDark,
      primaryColorLight: primary,
      fontFamily: 'ProductSans',
      unselectedWidgetColor: Colors.black12,
      buttonColor: buttonColorLight,
      focusColor: primary,
      cardColor: Theme.of(context).canvasColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: accent.withAlpha(50)
      ),
      cursorColor: primary,
      dialogBackgroundColor: Theme.of(context).canvasColor,
      buttonBarTheme: ButtonBarThemeData(
        buttonPadding: EdgeInsets.all(20),
      ),
      tabBarTheme: TabBarTheme(
          labelColor: primary,
          unselectedLabelColor: primary.withAlpha(100),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            color: primary,
          )),
      dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
              color: primary,
              fontSize: Theme.of(context).textTheme.headline6.fontSize),
          contentTextStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontSize: Theme.of(context).textTheme.bodyText1.fontSize),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(
                  width: 1, color: Colors.black.withAlpha(20))),
          elevation: 12),
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        headline2: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        headline3: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        headline4: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        headline5: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        headline6: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        bodyText1: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        bodyText2: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        subtitle1: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        subtitle2: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
        caption: TextStyle(
          color: Colors.grey.shade800,
          fontFamily: 'ProductSans',
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 12,
        shadowColor: Colors.black.withAlpha(60),
      ),
      cardTheme: CardTheme(
        color: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side:
            BorderSide(width: 1, color: Colors.black.withAlpha(40))),
        shadowColor: Colors.black.withAlpha(60),
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primary,
        focusColor: primary,
        highlightColor: primary,
        hoverColor: primary,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primary,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: primary,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primary,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        disabledElevation: 0,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 12,
        backgroundColor: accent,
        foregroundColor: primaryDark
      ),
    );
  }

  static Color warningColor(BuildContext context) {
    Color color = Colors.amber[800];
    return color;
  }

  static Color errorColor(BuildContext context) {
    Color color = Colors.redAccent[400];
    return color;
  }
}