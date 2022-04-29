import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/friend_service.dart';

class FriendProvider extends ChangeNotifier {
  List<dynamic> contacts = [];

  final FriendService _service = FriendService();

  getContacts() {
    _service.contactStreamController.stream.listen((contactList) {
      contacts = contactList;
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
