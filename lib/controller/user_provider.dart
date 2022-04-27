// ignore_for_file: unused_field, prefer_final_fields
import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/user_service.dart';

class UserProvider extends ChangeNotifier {
  late UserService _service;
  late CustomUser _user;
  List<CustomUser> _usersList = [];
  List<CustomUser> get usersList => _usersList;
  CustomUser get user => _user;
  UserProvider() {
    _service = UserService();
    _user = _service.currentUser;
  }

  getCurrentUser() async {
    await for (var event in _service.cusUserController.stream) {
      _user = event;
      notifyListeners();
    }
  }

  Future<dynamic> getOtherUsers() async {
    final users = await _service.getOtherUsers();
    _usersList = users ?? [];
    notifyListeners();
    return users;
  }

  updateCurrUser({
    String? displayName,
    String? status,
  }) async {
    await _service.updateUserData(displayName: displayName, status: status);
    notifyListeners();
  }
}
