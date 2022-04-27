import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/contact_service.dart';

class ContactProvider extends ChangeNotifier {
  List<dynamic> contacts = [];

  final ContactService _service = ContactService();

  getContacts() {
    _service.contactStreamController.stream.listen((contactList) {
      contacts = contactList;
      log(contactList.toString());
      notifyListeners();
    });
  }

  Future<void> addContact(CustomUser newContact) async {
    await _service.addToContact(newContact);
    notifyListeners();
  }

  removeContact() {
    notifyListeners();
  }
}
