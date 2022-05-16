// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/message.dart';
import 'package:streaming/services/database/database_service.dart';

class ChatRoomService extends DatabaseService {
  StreamController _chatStreamController = StreamController.broadcast();
  StreamController get chatStreamController => _chatStreamController;
  late StreamSubscription _chatStreamSubscription;

  StreamController _roomStreamController = StreamController.broadcast();
  StreamController get roomStreamController => _roomStreamController;
  late StreamSubscription _roomStreamSubscription;

  CustomUser get currentUser => DatabaseService.user;

  /// CONSTRUCTOR ///
  ChatRoomService() {
    addStream();
  }

  /// METHODS ///

  @override
  void addStream({String? roomId}) {
    _chatStreamSubscription = getMessages(roomId: roomId).listen((event) {
      _chatStreamController.add(event);
    });

    _roomStreamSubscription = getChatRooms().listen((event) {
      _roomStreamController.add(event);
    });
  }

  @override
  Future<void> cleanupStream() async {
    await _chatStreamSubscription.cancel();
    await _roomStreamSubscription.cancel();
    await _chatStreamController.stream.drain();
    await _roomStreamController.stream.drain();
  }

// # ROOM # //

  // creating a chatroom for two users
  Future createChatRoom(CustomUser participent2) async {
    // checking if we already are in a room with this user
    final alreadyExists = await checkIfChatRoomExists(participent2.uid);
    if (alreadyExists) {
      return;
    }

    // adding the two users and their ids to roomDoc in Rooms collection
    await rooms.add({
      // "participents": [currentUser.toJson(), participent2.toJson()],
      "participentIds": [currentUser.uid, participent2.uid]
    }).then((generatedRoom) {
      // adding a field roomId to the newly created room.
      rooms.doc(generatedRoom.id).update({"roomId": generatedRoom.id});

      // adding the current room ID to user1
      users.doc(currentUser.uid).update({
        "rooms": FieldValue.arrayUnion([generatedRoom.id])
      });

      // adding the current room ID to user2
      users.doc(participent2.uid).update({
        "rooms": FieldValue.arrayUnion([generatedRoom.id])
      });
    });
  }

  // get the chatrooms the user has
  Stream<List<ChatRoom>> getChatRooms() async* {
    List<ChatRoom> chatRooms = [];
    // get the rooms where the current user is present
    final chatRoomStream = rooms
        .where("participentIds", arrayContains: currentUser.uid)
        .snapshots();

    // getting all the chatrooms the user is a part of.
    await for (var snap in chatRoomStream) {
      List<ChatRoom> tempList = [];
      for (var doc in snap.docs) {
        final json = doc.data() as Map<String, dynamic>;

        // get the chatrooms and create its instance
        final chatRoomObj = ChatRoom.fromJson(json);
        final participentsRaw =
            await users.where("uid", whereIn: chatRoomObj.participentIds).get();

        // get the users in the chatroom using their userId from the chatRoomObj
        List<CustomUser> particpentsList = participentsRaw.docs
            .map((e) =>
                CustomUser.fromJson(json: e.data() as Map<String, dynamic>))
            .toList();

        // assign the users as participents of the chatroom.
        chatRoomObj.setParticipents(particpentsList);
        tempList.add(chatRoomObj);
      }
      chatRooms = tempList;
      yield chatRooms;
    }
  }

  // checks if user already exists in the chatroom that
  // is about to be created.
  Future<bool> checkIfChatRoomExists(String endUserId) async {
    try {
      final userInRoom = await rooms
          .where("participentsIds", arrayContains: endUserId)
          .limit(1)
          .get();
      if (userInRoom.docs.isEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

// # MESSAGES # //

  // send message to the endUser
  Future<bool> sendMessage(String roomId, Message msg) async {
    try {
      DocumentReference msgDocRef =
          rooms.doc(roomId).collection("messages").doc();

      msg.msgId = msgDocRef.id;
      await msgDocRef.set(msg.toJson()).then((value) {
        rooms.doc(roomId).update(
          {"lastMessage": msg.toJson()},
        );
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future updateMessageStatus(Message msg, String roomId) async {
    try {
      if (msg.status == "seen") {
        return;
      }
      rooms
          .doc(roomId)
          .collection("messages")
          .doc(msg.msgId)
          .update({"status": "seen"}).then((value) => rooms.doc(roomId).update(
                {"lastMessage": msg.toJson()},
              ));
    } catch (e) {
      rethrow;
    }
  }

  // get stream of messages.
  Stream<List<Message>> getMessages({String? roomId}) async* {
    // looping through the messages in the room
    if (roomId != null) {
      await for (var data in rooms
          .doc(roomId)
          .collection("messages")
          .orderBy("sentAt", descending: true)
          .snapshots()) {
        // the changes of the status is done inside the user model.
        List<Message> messageList =
            data.docs.map((doc) => Message.fromJson(doc.data())).toList();
        // if there's any change, user is notified.
        yield messageList;
      }
    }
  }
}
