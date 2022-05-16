// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streaming/models/enums.dart';

// common
Color kGrey = Colors.grey.shade700;
Color kBlack = Colors.grey.shade900;
Color kWhite = Colors.white;
Color kOffWhite = Colors.grey.shade100;

// Light theme colors
// Color kLightTextContainerMe = Colors.orangeAccent.shade200;
// Color kLightTextContainerOthers = Colors.deepOrangeAccent.shade100;
Color kLightBottomAppBar = Colors.grey.shade200;
Color kLightTextFieldFill = const Color.fromARGB(255, 237, 237, 237);
Color kLightAppBar = Colors.white;
Color kLightHintColor = Colors.grey.shade400;
Color kLightDividerColor = const Color.fromARGB(255, 190, 190, 190);
Color kLightAccentColor = Colors.orangeAccent.shade400;
Color kLightPrimaryColorLight = const Color.fromARGB(255, 137, 137, 137);

// Dark theme colors
// Color kDarkTextContainerMe = Colors.green;
// Color kDarkTextContainerOthers = Colors.green.shade700;
Color kDarkBottomAppBar = Colors.grey.shade800;
Color kDarkTextFieldFill = const Color.fromARGB(255, 59, 59, 59);
Color kDarkAppBar = const Color.fromARGB(255, 42, 42, 42);
Color kDarkBtnColor = const Color.fromARGB(255, 27, 178, 105);
Color kDarkHintColor = const Color.fromARGB(255, 168, 168, 168);
Color kDarkAccentColor = Colors.greenAccent;
Color kDarkPrimaryColorLight = Colors.grey;
Color kDarkDividerColor = const Color.fromARGB(255, 179, 179, 179);

// dynamic, changes with theme.
late Color _kTextContainerMe;
late Color _kTextContainerOthers;

Color get kTextContainerMe => _kTextContainerMe;
Color get kTextContainerOthers => _kTextContainerOthers;

void setkTextContainerColors(CusTheme currentTheme) {
  switch (currentTheme) {
    case CusTheme.Light:
      _kTextContainerMe = Colors.orange.shade200;
      _kTextContainerOthers = const Color.fromARGB(255, 255, 234, 198);
      break;
    case CusTheme.Dark:
      _kTextContainerMe = const Color.fromARGB(255, 38, 167, 100);
      _kTextContainerOthers = const Color.fromARGB(255, 39, 131, 84);
      break;

    case CusTheme.Sunset:
      _kTextContainerMe = Colors.orangeAccent.shade200;
      _kTextContainerOthers = Colors.deepOrangeAccent.shade100;
      break;
  }
}

String dateFormatter(String dateStr) {
  String date = "";

  if (dateStr == "null") {
    return "";
  }
  date = DateFormat()
      .add_jm()
      .format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateStr));

  return date;
}
