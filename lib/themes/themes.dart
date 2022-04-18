// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:streaming/constants.dart';

enum CusTheme { Light, Dark, Sunset }

class CustomThemes {
  static ThemeData get Light {
    ThemeData LightTheme = ThemeData(
        primaryColor: kWhite,
        backgroundColor: kWhite,
        bottomAppBarColor: kOffWhite,
        scaffoldBackgroundColor: kWhite,
        fontFamily: "Brandon",
        hintColor: kGrey,
        iconTheme: IconThemeData(color: kGrey),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: kLightAccentColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: kBlack, fontWeight: FontWeight.w300, fontSize: 18.0),
            bodyText2: TextStyle(
                color: kBlack, fontWeight: FontWeight.w200, fontSize: 14.0),
            headline1: TextStyle(
                color: kBlack, fontWeight: FontWeight.w700, fontSize: 40.0)));
    LightTheme = LightTheme.copyWith(
        textSelectionTheme:
            LightTheme.textSelectionTheme.copyWith(cursorColor: kBlack));
    LightTheme = LightTheme.copyWith(
        colorScheme:
            LightTheme.colorScheme.copyWith(secondary: kLightAccentColor));
    return LightTheme;
  }

  static ThemeData get Dark {
    ThemeData DarkTheme = ThemeData(
        primaryColor: kBlack,
        backgroundColor: kGrey,
        bottomAppBarColor: KBottomAppBar,
        scaffoldBackgroundColor: kBlack,
        fontFamily: "Brandon",
        hintColor: kOffWhite,
        iconTheme: IconThemeData(color: kWhite),
        selectedRowColor: kBlackAccentColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: kBtnColorDark,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))),
        textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 18.0,
              color: kOffWhite,
              fontWeight: FontWeight.w300,
            ),
            bodyText2: TextStyle(
              fontSize: 14.0,
              color: kWhite,
              fontWeight: FontWeight.w200,
            ),
            headline1: TextStyle(
              fontSize: 40.0,
              color: kOffWhite,
              fontWeight: FontWeight.w600,
            )));

    DarkTheme = DarkTheme.copyWith(
        textSelectionTheme:
            DarkTheme.textSelectionTheme.copyWith(cursorColor: kOffWhite));
    DarkTheme = DarkTheme.copyWith(
        colorScheme:
            DarkTheme.colorScheme.copyWith(secondary: kBlackAccentColor));
    return DarkTheme;
  }
}
