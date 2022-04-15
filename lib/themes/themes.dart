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
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: kBlack, fontWeight: FontWeight.w300, fontSize: 18.0),
            bodyText2: TextStyle(
                color: kBlack, fontWeight: FontWeight.w200, fontSize: 14.0),
            headline1: TextStyle(
                color: kBlack, fontWeight: FontWeight.w600, fontSize: 14.0)));
    LightTheme = LightTheme.copyWith(
        textSelectionTheme:
            LightTheme.textSelectionTheme.copyWith(cursorColor: kBlack));
    LightTheme = LightTheme.copyWith(
        colorScheme: LightTheme.colorScheme.copyWith(secondary: kOrange));
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
        selectedRowColor: kGreen,
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: kOffWhite, fontWeight: FontWeight.w300, fontSize: 18.0),
            bodyText2: TextStyle(
                color: kWhite, fontWeight: FontWeight.w200, fontSize: 14.0)));

    DarkTheme = DarkTheme.copyWith(
        textSelectionTheme:
            DarkTheme.textSelectionTheme.copyWith(cursorColor: kOffWhite));
    DarkTheme = DarkTheme.copyWith(
        colorScheme: DarkTheme.colorScheme.copyWith(secondary: kGreen));
    return DarkTheme;
  }
}
