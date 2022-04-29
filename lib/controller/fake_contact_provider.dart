// ignore_for_file: prefer_final_fields
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/friend.dart';
import 'package:streaming/services/fake_friends_service.dart';
import 'package:streaming/services/shared_preferences.dart';

class FakeFriendProvider extends ChangeNotifier {
  List<Friend> _contactsList = [];

  FakeFriendService service = FakeFriendService();

  UnmodifiableListView<Friend> get contactsList =>
      UnmodifiableListView(_contactsList);

  getContacts() async {
    _contactsList = service.getContacts();
    CustomPreferences.setContactsList(_contactsList);
    notifyListeners();
  }
}
