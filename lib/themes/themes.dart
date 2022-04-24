// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:streaming/constants.dart';

class CustomThemes {
  static ThemeData get Light {
    ThemeData LightTheme = ThemeData(
        primaryColor: kWhite,
        backgroundColor: kWhite,
        bottomAppBarColor: kOffWhite,
        scaffoldBackgroundColor: kWhite,
        fontFamily: "Brandon",
        hintColor: kLightHintColor,
        iconTheme: IconThemeData(color: kGrey),
        dividerColor: kLightDividerColor,
        primaryColorLight: kLightPrimaryColorLight,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: kLightAccentColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)))),
        textTheme: TextTheme(
          bodyText1: TextStyle(
              color: kBlack, fontWeight: FontWeight.w300, fontSize: 18.0),
          bodyText2: TextStyle(
              color: kBlack, fontWeight: FontWeight.w200, fontSize: 14.0),
          headline1: TextStyle(
            fontSize: 40.0,
            color: kBlack,
            fontWeight: FontWeight.w600,
          ),
          headline2: TextStyle(
            fontSize: 36.0,
            color: kBlack,
            fontWeight: FontWeight.w500,
          ),
          headline3: TextStyle(
            fontSize: 28.0,
            color: kBlack,
            fontWeight: FontWeight.w500,
          ),
          headline4: TextStyle(
            fontSize: 22.0,
            color: kBlack,
            fontWeight: FontWeight.w500,
          ),
          headline6: TextStyle(
            fontSize: 18.0,
            color: kBlack,
            fontWeight: FontWeight.w500,
          ),
        ));
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
        hintColor: kDarkHintColor,
        iconTheme: IconThemeData(color: kWhite),
        selectedRowColor: kDarkAccentColor,
        dividerColor: kDarkDividerColor,
        primaryColorLight: kDarkPrimaryColorLight,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: kDarkBtnColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 16.0,
            color: kOffWhite,
            fontWeight: FontWeight.w300,
          ),
          bodyText2: TextStyle(
            fontSize: 18.0,
            color: kOffWhite,
            fontWeight: FontWeight.w400,
          ),
          headline1: TextStyle(
            fontSize: 40.0,
            color: kOffWhite,
            fontWeight: FontWeight.w600,
          ),
          headline2: TextStyle(
            fontSize: 36.0,
            color: kOffWhite,
            fontWeight: FontWeight.w500,
          ),
          headline3: TextStyle(
            fontSize: 28.0,
            color: kOffWhite,
            fontWeight: FontWeight.w500,
          ),
          headline4: TextStyle(
            fontSize: 22.0,
            color: kOffWhite,
            fontWeight: FontWeight.w500,
          ),
          headline6: TextStyle(
            fontSize: 18.0,
            color: kOffWhite,
            fontWeight: FontWeight.w500,
          ),
        ));

    DarkTheme = DarkTheme.copyWith(
        textSelectionTheme:
            DarkTheme.textSelectionTheme.copyWith(cursorColor: kOffWhite));
    DarkTheme = DarkTheme.copyWith(
        colorScheme:
            DarkTheme.colorScheme.copyWith(secondary: kDarkAccentColor));
    return DarkTheme;
  }
}
