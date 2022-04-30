// ignore_for_file: prefer_final_fields
import 'package:flutter/cupertino.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/database/friend_service.dart';

class FriendProvider extends ChangeNotifier {
  /// DECLARATIONS ///
  late FriendService _service;
  List<CustomUser?> _friends = [];
  List<CustomUser?> _requests = [];
  late DataState _currentState;
  late ChildWidgetState _childWidgetState;

  /// GETTERS ///
  List<CustomUser?> get friends => _friends;
  List<CustomUser?> get requests => _requests;
  DataState get currentState => _currentState;
  ChildWidgetState get childWidgetState => _childWidgetState;

  /// SETTERS ///
  void setCurrState(DataState newState) {
    _currentState = newState;
    notifyListeners();
  }

  void setWidgetState(ChildWidgetState newState) {
    _childWidgetState = newState;
    notifyListeners();
  }

  /// CONSTRUCTOR ///
  FriendProvider() {
    _currentState = DataState.waiting;
    _childWidgetState = ChildWidgetState.done;
    _service = FriendService();
    getFriendRequests();
  }

  /// METHODS ///

  // stream of friends
  getFriends() {
    _service.friendStreamController.stream.listen((friendsList) {
      _friends = friendsList;
      notifyListeners();
    }, onError: (err) => _currentState = DataState.error);
  }

  // stream of requests.
  getFriendRequests() {
    _service.friendReqStreamController.stream.listen((requestsLists) {
      _requests = requestsLists;
      notifyListeners();
      _currentState = DataState.done;
    }, onError: (err) => _currentState = DataState.error);
  }

  // accept request and add friend
  Future<void> addFriend(CustomUser newContact) async {
    await _service.addToFriends(newContact);
    _childWidgetState = ChildWidgetState.done;
    notifyListeners();
  }

  Future<bool> sendFriendRequest(String name) async {
    bool success = false;
    try {
      success = await _service.sendRequest(name);
      notifyListeners();
      return success;
    } catch (e) {
      rethrow;
    }
  }

  unFriend() {
    notifyListeners();
  }

  /// DEFAULTS ///
  listenToStream() {
    _service.addStream();
  }

  cleanupStream() async {
    await _service.cleanupStream();
  }
}
