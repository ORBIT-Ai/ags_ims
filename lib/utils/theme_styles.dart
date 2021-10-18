import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  Color primaryColor = Colors.blueAccent[400];
  Color accent = Colors.cyanAccent;

  static ThemeData themeData({
    BuildContext context,
    bool isDarkTheme,
    bool isBluePalette,
    bool isCyanPalette,
    bool isAmberPalette,
    bool isIndigoPalette,
    bool isPurplePalette,
    bool isBlueGreyPalette,
    bool isBlackPalette,
    bool isRedPalette,
    bool isPinkPalette,
    bool isTealPalette,
    bool isGreenPalette,
  }) {
    Color primaryLight;
    Color accentLight;
    Color primaryLightDark;
    Color buttonColorLight;

    Color primaryDark;
    Color accentDark;
    Color primaryDarkLight;
    Color buttonColorDark;

    if (isBluePalette) {
      primaryLight = Colors.blueAccent[400];
      accentLight = Colors.blueAccent[400];
      primaryLightDark = Colors.blue[900];
      buttonColorLight = Colors.blueAccent[100];

      primaryDark = Colors.blueAccent[100];
      accentDark = Colors.blueAccent[100];
      primaryDarkLight = Colors.blueAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isCyanPalette) {
      primaryLight = Colors.cyan[600];
      accentLight = Colors.cyan[600];
      primaryLightDark = Colors.cyan[900];
      buttonColorLight = Colors.cyanAccent[100];

      primaryDark = Colors.cyanAccent[100];
      accentDark = Colors.cyanAccent[100];
      primaryDarkLight = Colors.cyanAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isAmberPalette) {
      primaryLight = Colors.amber[600];
      accentLight = Colors.amber[600];
      primaryLightDark = Colors.amberAccent[700];
      buttonColorLight = Colors.amberAccent[100];

      primaryDark = Colors.amberAccent[100];
      accentDark = Colors.amberAccent[100];
      primaryDarkLight = Colors.amberAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isIndigoPalette) {
      primaryLight = Colors.indigoAccent[400];
      accentLight = Colors.indigoAccent[400];
      primaryLightDark = Colors.indigo[700];
      buttonColorLight = Colors.indigoAccent[100];

      primaryDark = Colors.indigoAccent[100];
      accentDark = Colors.indigoAccent[100];
      primaryDarkLight = Colors.indigoAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isPurplePalette) {
      primaryLight = Colors.purpleAccent[400];
      accentLight = Colors.purpleAccent[400];
      primaryLightDark = Colors.purple[900];
      buttonColorLight = Colors.purpleAccent[100];

      primaryDark = Colors.purpleAccent[100];
      accentDark = Colors.purpleAccent[100];
      primaryDarkLight = Colors.purpleAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isBlueGreyPalette) {
      primaryLight = Colors.blueGrey[300];
      accentLight = Colors.blueGrey[300];
      primaryLightDark = Colors.blueGrey[500];
      buttonColorLight = Colors.blueGrey[300];

      primaryDark = Colors.blueGrey[600];
      accentDark = Colors.blueGrey[600];
      primaryDarkLight = Colors.blueGrey[600];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isBlackPalette) {
      primaryLight = Colors.grey[800];
      accentLight = Colors.grey[800];
      primaryLightDark = Colors.grey[900];
      buttonColorLight = Colors.grey[900];

      primaryDark = Colors.white;
      accentDark = Colors.white;
      primaryDarkLight = Colors.white;
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isRedPalette) {
      primaryLight = Colors.redAccent[400];
      accentLight = Colors.redAccent[400];
      primaryLightDark = Colors.redAccent[700];
      buttonColorLight = Colors.redAccent[100];

      primaryDark = Colors.redAccent[100];
      accentDark = Colors.redAccent[100];
      primaryDarkLight = Colors.redAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isPinkPalette) {
      primaryLight = Colors.pink[500];
      accentLight = Colors.pink[500];
      primaryLightDark = Colors.pink[600];
      buttonColorLight = Colors.pink[100];

      primaryDark = Colors.pinkAccent[100];
      accentDark = Colors.pinkAccent[100];
      primaryDarkLight = Colors.pinkAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isTealPalette) {
      primaryLight = Colors.teal[500];
      accentLight = Colors.teal[500];
      primaryLightDark = Colors.teal[500];
      buttonColorLight = Colors.tealAccent[100];

      primaryDark = Colors.tealAccent[100];
      accentDark = Colors.tealAccent[100];
      primaryDarkLight = Colors.tealAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (isGreenPalette) {
      primaryLight = Colors.greenAccent[700];
      accentLight = Colors.greenAccent[700];
      primaryLightDark = Colors.green[700];
      buttonColorLight = Colors.greenAccent[100];

      primaryDark = Colors.greenAccent[100];
      accentDark = Colors.greenAccent[100];
      primaryDarkLight = Colors.greenAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }
    if (!isCyanPalette &&
        !isAmberPalette &&
        !isIndigoPalette &&
        !isPurplePalette &&
        !isBlueGreyPalette &&
        !isBlackPalette &&
        !isRedPalette &&
        !isPinkPalette &&
        !isTealPalette &&
        !isGreenPalette) {
      primaryLight = Colors.blueAccent[400];
      accentLight = Colors.blueAccent[400];
      primaryLightDark = Colors.blue[900];
      buttonColorLight = Colors.blueAccent[100];

      primaryDark = Colors.blueAccent[100];
      accentDark = Colors.blueAccent[100];
      primaryDarkLight = Colors.blueAccent[100];
      buttonColorDark = Colors.white.withAlpha(12);
    }

    return isDarkTheme == true
        ? ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      accentColor: accentDark,
      primaryColorDark: primaryDarkLight,
      fontFamily: 'Product Sans',
      unselectedWidgetColor: Colors.blueGrey[700].withAlpha(80),
      buttonColor: buttonColorDark,
      canvasColor: Colors.blueGrey[900],
      cardColor: Colors.blueGrey[900],
      dividerColor: Colors.blueGrey[700].withAlpha(80),
      dialogBackgroundColor: Colors.blueGrey[900],
      buttonBarTheme: ButtonBarThemeData(
        buttonPadding: EdgeInsets.all(20),
      ),
      iconTheme: IconThemeData(
        color: Colors.blueGrey.shade300,
      ),
      tabBarTheme: TabBarTheme(
          labelColor: primaryDark,
          unselectedLabelColor: primaryDark.withAlpha(100),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            color: primaryDark,
          )),
      dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
              color: primaryDark,
              fontSize: Theme.of(context).textTheme.headline6.fontSize),
          contentTextStyle: TextStyle(
              color: Colors.blueGrey.shade300,
              fontSize: Theme.of(context).textTheme.bodyText1.fontSize),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(width: 0, color: Colors.blueGrey[800])),
          elevation: 12,
          backgroundColor: Colors.blueGrey[900]),
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        headline2: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        headline3: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        headline4: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        headline5: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        headline6: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        bodyText1: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        bodyText2: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        subtitle1: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        subtitle2: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
        caption: TextStyle(
          color: Colors.blueGrey.shade300,
          fontFamily: 'ProductSans',
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 12,
        shadowColor: Colors.blueGrey[900].withAlpha(60),
      ),
      cardTheme: CardTheme(
          color: Colors.blueGrey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(width: 1, color: Colors.blueGrey[800])),
          elevation: 0),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryDark,
        focusColor: primaryDark,
        highlightColor: primaryDark,
        hoverColor: primaryDark,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryDark,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: primaryDark,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryDark,
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
      ),
    )
        : ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLight,
      accentColor: accentLight,
      primaryColorDark: primaryLightDark,
      primaryColorLight: primaryLight,
      fontFamily: 'ProductSans',
      unselectedWidgetColor: Colors.black12,
      buttonColor: buttonColorLight,
      focusColor: primaryLight,
      cardColor: Theme.of(context).canvasColor,
      cursorColor: primaryLight,
      dialogBackgroundColor: Theme.of(context).canvasColor,
      buttonBarTheme: ButtonBarThemeData(
        buttonPadding: EdgeInsets.all(20),
      ),
      tabBarTheme: TabBarTheme(
          labelColor: primaryLight,
          unselectedLabelColor: primaryLight.withAlpha(100),
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            color: primaryLight,
          )),
      dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
              color: primaryLight,
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
        buttonColor: primaryLight,
        focusColor: primaryLight,
        highlightColor: primaryLight,
        hoverColor: primaryLight,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryLight,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: primaryLight,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryLight,
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

  static Color badgeColor(
      {isVerified,
        isPopular,
        isReported,
        isLocked,
        isUnVerified,
        isPublicPost,
        isFriendOnlyPost,
        isPrivatePost,
        isFeaturedPost}) {
    Color verifiedUser,
        popularUser,
        reportedUser,
        lockedUser,
        unVerifiedUser,
        publicPost,
        friendsOnlyPost,
        privatePost,
        featuredPost;

    verifiedUser = Colors.blueAccent[400];
    popularUser = Colors.cyanAccent[400];
    reportedUser = Colors.amber[700];
    lockedUser = Colors.amber[700];
    unVerifiedUser = Colors.amber[700];
    publicPost = Colors.blueAccent[400];
    friendsOnlyPost = Colors.blueAccent[400];
    privatePost = Colors.deepOrangeAccent[400];
    featuredPost = Colors.cyanAccent[400];

    return isVerified != null && isVerified
        ? verifiedUser
        : isPopular != null && isPopular
        ? popularUser
        : isReported != null && isReported
        ? reportedUser
        : isLocked != null && isLocked
        ? lockedUser
        : isUnVerified != null && isUnVerified
        ? unVerifiedUser
        : isPublicPost != null && isPublicPost
        ? publicPost
        : isFriendOnlyPost != null && isFriendOnlyPost
        ? friendsOnlyPost
        : isPrivatePost != null && isPrivatePost
        ? privatePost
        : isFeaturedPost != null && isFeaturedPost
        ? featuredPost
        : Colors.white;
  }
}