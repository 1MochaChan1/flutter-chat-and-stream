// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming/models/contact.dart';
import 'package:streaming/themes/themes.dart';

class CustomPreferences {
  static const CONTACTS = "CONTACTS_LIST";
  static const CURR_THEME = "CURRENT_THEME";

  // setters

  static Future<bool> setCurrentTheme(CusTheme theme) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(CURR_THEME, theme.name);
    } catch (e) {
      rethrow;
    }

    return true;
  }

  static Future<bool> setContactsList(List<Contact> contacts) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final contactsEncoded = jsonEncode(contacts);
      prefs.setString(CONTACTS, contactsEncoded);
    } catch (e) {
      rethrow;
    }
    return true;
  }

  // getters

  static Future<CusTheme> getCurrentTheme() async {
    CusTheme theme = CusTheme.Light;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var curThemeStr = pref.getString(CURR_THEME);
      if (curThemeStr != null) {
        CusTheme curTheme =
            CusTheme.values.firstWhere((_theme) => _theme.name == curThemeStr);
        theme = curTheme;
      } else {
        theme = CusTheme.Light;
      }
    } catch (e) {
      rethrow;
    }
    return theme;
  }

  static Future<List<Contact>> getContactsList() async {
    List<Contact> contactsList = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? rawContacts = prefs.getString(CONTACTS);
      var decodedList = jsonDecode(rawContacts ?? "");
      for (var json in decodedList) {
        contactsList.add(Contact.fromJson(json));
      }
    } catch (e) {
      rethrow;
    }
    return contactsList;
  }
}
