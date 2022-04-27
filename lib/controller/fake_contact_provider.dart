// ignore_for_file: prefer_final_fields
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/contact.dart';
import 'package:streaming/services/contact_service.dart';
import 'package:streaming/services/shared_preferences.dart';

class FakeContactProvider extends ChangeNotifier {
  List<Contact> _contactsList = [];

  FakeContactService service = FakeContactService();

  UnmodifiableListView<Contact> get contactsList =>
      UnmodifiableListView(_contactsList);

  getContacts() async {
    _contactsList = service.getContacts();
    CustomPreferences.setContactsList(_contactsList);
    notifyListeners();
  }
}
