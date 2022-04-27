// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming/models/contact.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';

class CustomPreferences {
  static const CONTACTS = "CONTACTS_LIST";
  static const CURR_THEME = "CURRENT_THEME";
  static const SHOW_INTRO = "SHOW_INTRO";
  static const CURR_USER = "CURRENT_USER";

  // setters
  static Future<bool> setCurrentTheme(CusTheme theme) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(CURR_THEME, theme.name);
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

  static Future<bool> setShowIntro(bool showIntro) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(SHOW_INTRO, showIntro);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> setCurrUser(CustomUser? user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userEncoded = jsonEncode(user);
      prefs.setString(CURR_USER, userEncoded);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // getters
  static Future<CusTheme> getCurrentTheme() async {
    CusTheme theme = CusTheme.Light;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var curThemeStr = prefs.getString(CURR_THEME);
      if (curThemeStr != null) {
        CusTheme curTheme =
            CusTheme.values.firstWhere((_theme) => _theme.name == curThemeStr);
        theme = curTheme;
      } else {
        theme = CusTheme.Dark;
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

  static Future<bool> getShowIntro() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool? showIntro = pref.getBool(SHOW_INTRO);
      return showIntro ?? true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<CustomUser?> getCurrUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var currUserRaw = prefs.getString(CURR_USER);
      if (currUserRaw == "null" || currUserRaw == null) return null;

      var currUserJson = jsonDecode(currUserRaw);
      CustomUser cusUser = CustomUser.fromJson(json: currUserJson);
      return cusUser;
    } catch (e) {
      rethrow;
    }
  }
}
