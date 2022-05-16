import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:streaming/controller/chatroom_provider.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/models/message.dart';
import 'package:streaming/services/database/chatroom_service.dart';
import 'package:test/test.dart';

class MockChatRoomService implements ChatRoomService {
  /// TEST CASE ///
  bool switcher = false;
  Future<List<Message>> getTestMessages() async {
    return [
      generateMessages("Hey"),
      generateMessages("Hi"),
      generateMessages("Don't know what to say"),
      generateMessages("It's just a test, dw."),
      generateMessages("Oh Alright, wanna play some co-op horror?"),
      generateMessages("Yeah! I love horror stuff"),
      generateMessages("You got a decent PC to run em?"),
      generateMessages("Yeah got a RX550 and an i3"),
      generateMessages("Cool..."),
      generateMessages("I know not much, but it works"),
      generateMessages("Bruh I run on integrated graphics.")
    ];
  }

  Message generateMessages(String text) {
    switcher = !switcher;
    return Message(
      sentBy: switcher
          ? "TAHh8DJzr7cqnzurYP6CjoYxcq52"
          : "T7aZYlKRQMhmRsgO0IyleJEhq4n1",
      text: text,
      status: "sent",
      sentAt: FieldValue.serverTimestamp(),
    );
  }

  /// AFTER THIS EVERYTHING IS OOGABOOGA ///

  @override
  late CollectionReference<Object?> friends;

  @override
  late NumberFormat numFormat;

  @override
  late CollectionReference<Object?> requests;

  @override
  late CollectionReference<Object?> rooms;

  @override
  late CollectionReference<Object?> users;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStream({String? roomId}) {
    // TODO: implement addStream
  }

  @override
  StreamController get chatStreamController => StreamController();

  @override
  Future<bool> checkIfChatRoomExists(String endUserId) {
    // TODO: implement checkIfChatRoomExists
    throw UnimplementedError();
  }

  @override
  Future<void> cleanupStream() {
    // TODO: implement cleanupStream
    throw UnimplementedError();
  }

  @override
  Future createChatRoom(CustomUser participent2) {
    // TODO: implement createChatRoom
    throw UnimplementedError();
  }

  @override
  CustomUser get currentUser => CustomUser(uid: "uid");

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Stream<List<ChatRoom>> getChatRooms() {
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> getMessages({String? roomId}) {
    throw UnimplementedError();
  }

  @override
  bool get hasListeners => true;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  // TODO: implement roomStreamController
  StreamController get roomStreamController => StreamController();

  @override
  Future<bool> sendMessage(String roomId, Message msg) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future setInitUser(CustomUser customUser) {
    // TODO: implement setInitUser
    throw UnimplementedError();
  }

  @override
  void setUser(CustomUser cusUser) {
    // TODO: implement setUser
  }

  @override
  Future updateMessageStatus(Message msg, String roomId) {
    // TODO: implement updateMessageStatus
    throw UnimplementedError();
  }
}

void main() {
  late ChatRoomProvider sut;

  setUp(() {
    sut = ChatRoomProvider(service: MockChatRoomService());
  });

  test(
      "testing if initial values of the provider are correct"
      "1. _rooms = []"
      "2. _messages = []"
      "3. _currentState = DataState.waiting", () {
    expect(sut.rooms, []);
    expect(sut.messages, []);
    expect(sut.currentState, DataState.waiting);
  });
}
