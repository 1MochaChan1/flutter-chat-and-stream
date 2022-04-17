import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/contact.dart';
import 'package:streaming/services/contact_service.dart';
import 'package:streaming/services/shared_preferences.dart';

class ContactProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Contact> _contactsList = [];

  ContactService service = ContactService();

  UnmodifiableListView<Contact> get contactsList =>
      UnmodifiableListView(_contactsList);

  getContacts() async {
    _contactsList = service.getContacts();
    CustomPreferences.setContactsList(_contactsList);
    notifyListeners();
  }
}
