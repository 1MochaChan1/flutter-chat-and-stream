import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/friend_service.dart';

class FriendProvider extends ChangeNotifier {
  List<dynamic> _friends = [];
  List<dynamic> get friends => _friends;
  List<dynamic> _requests = [];
  List<dynamic> get requests => _requests;

  late FriendService _service;
  FriendProvider() {
    _service = FriendService();
    getFriendRequests();
  }

  getFriends() {
    _service.friendStreamController.stream.listen((friendsList) {
      _friends = friendsList;
      notifyListeners();
    });
  }

  getFriendRequests() {
    _service.friendReqStreamController.stream.listen((requestsLists) {
      _requests = requestsLists;
      notifyListeners();
    });
  }

  Future<void> addFriend(CustomUser newContact) async {
    await _service.addToFriends(newContact);
    notifyListeners();
  }

  unFriend() {
    notifyListeners();
  }

  listenToStream() {
    _service.addStream();
  }

  cleanupStream() async {
    await _service.cleanupStream();
  }
}
