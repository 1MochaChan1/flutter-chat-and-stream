// ignore_for_file: unused_field, prefer_final_fields
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/database/user_service.dart';

class UserProvider extends ChangeNotifier {
  // declarations
  late UserService _service;
  late CustomUser? _user;
  late StreamController _controller;
  List<CustomUser> _usersList = [];
  DataState _currentState = DataState.done;

  // getters
  StreamController get controller => _controller;
  List<CustomUser> get usersList => _usersList;
  DataState get currentState => _currentState;
  CustomUser get user => _user!;

  // constructors
  UserProvider() {
    _service = UserService();
    _user = _service.currentUser;
    _controller = _service.cusUserController;
    getCurrentUser();
  }

  // gets the value from the stream and notifies
  getCurrentUser() async {
    _service.cusUserController.stream.listen((event) {
      _currentState = DataState.waiting;
      _user = event;
      notifyListeners();
      _currentState = DataState.done;
    }, onError: (error) {
      _currentState = DataState.error;
    });
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
    _service.addStream();
    notifyListeners();
  }

  // cleans up the existing stream.
  Future cleanupStream() async {
    await _service.cleanupStream();
    notifyListeners();
  }
}
