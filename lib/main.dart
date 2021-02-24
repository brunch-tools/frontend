import 'package:brunch_tools/pages/HomePage.dart';
import 'package:brunch_tools/pages/SetupPage.dart';
import 'package:brunch_tools/pages/InstallAsPWA.dart';
import 'package:brunch_tools/utilities/JsCommons.dart';
import 'package:brunch_tools/utilities/JsLocalStorage.dart';
import 'package:flutter/material.dart';

void main() {
  Widget goTo = InstallAsPWA();
  ThemeData themeData = Constants.getTheme();
  if(JsCommons.isStandalone() || JsLocalStorage.get("debug-mode") == "true") {
    if(JsLocalStorage.get("is-installed") == "true") {
      goTo = HomePage();
    } else {
      goTo = SetupPage();
    }
  }
  if(JsLocalStorage.get("dark-mode") == "true") {
    themeData = Constants.getDarkTheme();
  }
  runApp(MaterialApp(
    title: "Brunch Tools",
    home: goTo,
    theme: themeData,
  ));
}

class Constants {
  static ThemeData getTheme() {
    return ThemeData.light().copyWith(
      textTheme: ThemeData.light().textTheme.copyWith(
        subtitle2: TextStyle(fontFamily: 'Poppins'),
        subtitle1: TextStyle(fontFamily: 'Poppins'),
        overline: TextStyle(fontFamily: 'Poppins'),
        caption: TextStyle(fontFamily: 'Poppins'),
        button: TextStyle(fontFamily: 'Poppins'),
        headline1: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color.fromRGBO(39, 39, 39, 1)),
        bodyText1: TextStyle(fontFamily: 'Poppins', color: Color.fromRGBO(39, 39, 39, 1)),
        bodyText2: TextStyle(fontFamily: 'Poppins', color: Color.fromRGBO(39, 39, 39, 1)),
        headline2: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color.fromRGBO(39, 39, 39, 1)),
        headline3: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color.fromRGBO(39, 39, 39, 1)),
        headline4: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, color: Color.fromRGBO(75, 75, 75, 1)),
        headline5: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, color: Color.fromRGBO(134, 134, 134, 1)),
        headline6: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, color: Color.fromRGBO(134, 134, 134, 1)),
      ),
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      buttonColor: Colors.blue,
      disabledColor: Color.fromRGBO(97, 97, 97, 1),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.dark()
      ),
      highlightColor: Colors.blue
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
        textTheme: ThemeData.light().textTheme.copyWith(
          subtitle2: TextStyle(fontFamily: 'Poppins'),
          subtitle1: TextStyle(fontFamily: 'Poppins'),
          overline: TextStyle(fontFamily: 'Poppins'),
          caption: TextStyle(fontFamily: 'Poppins'),
          button: TextStyle(fontFamily: 'Poppins'),
          headline1: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color.fromRGBO(200, 200, 200, 1)),
          bodyText1: TextStyle(fontFamily: 'Poppins', color: Color.fromRGBO(200, 200, 200, 1)),
          bodyText2: TextStyle(fontFamily: 'Poppins', color: Color.fromRGBO(200, 200, 200, 1)),
          headline2: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color.fromRGBO(200, 200, 200, 1)),
          headline3: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Color.fromRGBO(200, 200, 200, 1)),
          headline4: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, color: Color.fromRGBO(200, 200, 200, 1)),
          headline5: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, color: Color.fromRGBO(200, 200, 200, 1)),
          headline6: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, color: Color.fromRGBO(200, 200, 200, 1)),
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        buttonColor: Colors.orange,
        disabledColor: Color.fromRGBO(97, 97, 97, 1),
        buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light()
        ),
        highlightColor: Colors.blue,
        bottomAppBarColor: Colors.black
    );
  }

  static const String MIN_VERSION = "0.1.1";

}

class Register {
  static bool daemonUpdateComplete = false;
}