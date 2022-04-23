// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:streaming/services/shared_preferences.dart';
import 'package:streaming/themes/themes.dart';
import 'package:streaming/models/enums.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData currTheme;

  // this named constructor is to be called
  // inside the class
  ThemeProvider._init(CusTheme theme) {
    currTheme = toggle(theme);
  }

  // creating a class and returning it this way.
  // checks in sharedPrefs if a theme was selected
  // the last time
  // yes: restore theme and call toggle
  // no: return light theme
  static Future<ThemeProvider> init() async {
    CusTheme ctheme = await CustomPreferences.getCurrentTheme();
    ThemeProvider themeProviderInst = ThemeProvider._init(ctheme);
    return themeProviderInst;
  }

  // toggle between themes.
  ThemeData toggle(CusTheme theme) {
    switch (theme) {
      case CusTheme.Light:
        currTheme = CustomThemes.Light;
        break;
      case CusTheme.Dark:
        currTheme = CustomThemes.Dark;
        break;
      default:
        currTheme = CustomThemes.Light;
    }
    CustomPreferences.setCurrentTheme(theme);
    notifyListeners();
    return currTheme;
  }
}
