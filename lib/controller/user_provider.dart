// ignore_for_file: unused_field, prefer_final_fields
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/user_service.dart';

class UserProvider extends ChangeNotifier {
  late UserService _service;
  late CustomUser? _user;
  late StreamController _controller;
  StreamController get controller => _controller;
  List<CustomUser> _usersList = [];
  List<CustomUser> get usersList => _usersList;
  CustomUser get user => _user!;
  UserProvider() {
    _service = UserService();
    _user = _service.currentUser;
    _controller = _service.cusUserController;
    getCurrentUser();
  }

  // gets the value from the stream and notifies
  getCurrentUser() async {
    await for (var event in _service.cusUserController.stream) {
      _user = event;
      notifyListeners();
    }
  }

  // gets all the other users from the database except the current one.
  Future<dynamic> getOtherUsers() async {
    final users = await _service.getOtherUsers();
    _usersList = users ?? [];
    notifyListeners();
    return users;
  }

  // updates the details of the current user.
  updateCurrUser({
    String? displayName,
    String? status,
  }) async {
    await _service.updateUserData(displayName: displayName, status: status);
    notifyListeners();
  }

  // listen to the stream that gives current users data.
  listenToStream() {
    _service.addNewUserStream();
    notifyListeners();
  }

  // cancels stream subscription and tries to do a cleanup.
  cancelStream() async {
    await _service.cleanup();
    notifyListeners();
  }
}
