import 'dart:developer';

import 'package:streaming/models/abstract/custom_change_notifier.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/models/message.dart';
import 'package:streaming/services/database/chatroom_service.dart';

class ChatRoomProvider extends CustomChangeNotifier {
  /// DECLARATION ///
  late ChatRoomService _service;
  late CustomUser currentUser;
  bool _disposed = false;
  DataState _currentState = DataState.waiting;
  List<ChatRoom> _rooms = [];
  List<Message> _messages = [];

  /// GETTERS ///
  DataState get currentState => _currentState;
  List<ChatRoom> get rooms => _rooms;
  List<Message> get messages => _messages;

  /// SETTERS ///
  setCurrentState(DataState newState) {
    _currentState = newState;
    notifyListeners();
  }

  /// CONSTRUCTOR ///
  ChatRoomProvider() {
    _service = ChatRoomService();
    currentUser = _service.currentUser;
  }

  /// METHODS ///
  getChatRooms() async {
    try {
      _service.roomStreamController.stream.listen((event) {
        _rooms = event;
        _currentState = DataState.done;
        notifyListeners();
      });
    } catch (e) {
      _currentState = DataState.error;
      notifyListeners();
      rethrow;
    }
  }

  getMessages() {
    _service.chatStreamController.stream.listen((event) {
      _messages = event;
      notifyListeners();
    });
  }

  Future<bool> sendMessage(
      {required String roomId, required Message msg}) async {
    try {
      await _service.sendMessage(roomId, msg);
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  /// DEFAULT ///

  @override
  void cleanupStream() async {
    _currentState = DataState.waiting;
    await _service.cleanupStream();
    notifyListeners();
  }

  // loading the current user everytime they
  // start listening to stream.
  @override
  void listenToStream({String? roomId}) {
    currentUser = _service.currentUser;
    _service.addStream(roomId: roomId);
    // notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
