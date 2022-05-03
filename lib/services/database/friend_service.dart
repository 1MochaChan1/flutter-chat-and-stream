// ignore_for_file: prefer_final_fields, unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/database_service.dart';

class FriendService extends DatabaseService {
  /// DECLARATION ///
  StreamController _friendStreamController = StreamController.broadcast();
  StreamController get friendStreamController => _friendStreamController;
  late StreamSubscription _friendSubscription;

  StreamController _friendReqStreamController = StreamController.broadcast();
  StreamController get friendReqStreamController => _friendReqStreamController;
  late StreamSubscription _friendReqSubscription;
  CustomUser get currentUser => DatabaseService.user;

  /// CONSTRUCTOR ///
  FriendService() {
    addStream();
  }

  @override
  addStream() {
    _friendSubscription = getUserFriends().listen((event) {
      return _friendStreamController.add(event);
    });

    _friendReqSubscription = getFriendRequests().listen((event) {
      return _friendReqStreamController.add(event);
    });
  }

  @override
  Future cleanupStream() async {
    await _friendSubscription.cancel();
    await _friendStreamController.stream.drain();
    await _friendReqSubscription.cancel();
    await _friendReqStreamController.stream.drain();
  }

  /// METHODS ///

  // fetches current users friends list
  Stream<List<CustomUser?>> getUserFriends() async* {
    List<CustomUser?> contactList = [];
    CollectionReference userFriends =
        friends.doc(DatabaseService.user.uid).collection("userFriends");

    await for (var rec in userFriends.snapshots()) {
      List<CustomUser?> varList = [];
      for (var document in rec.docs) {
        final json = document.data() as Map<String, dynamic>;
        final cusUser = CustomUser.fromJson(json: json);
        varList.add(cusUser);
      }
      contactList = varList;
      yield contactList;
    }
  }

  // accepts a friends request and adds them to the friends list.
  Future<void> addToFriends(CustomUser reqSender) async {
    try {
      // adding the request sender to out friendsList
      await friends
          .doc(currentUser.uid)
          .collection("userFriends")
          .doc(reqSender.uid)
          .set(reqSender.toJson());

      // adding ourselves to the request sender's friendsList
      await friends
          .doc(reqSender.uid)
          .collection("userFriends")
          .doc(currentUser.uid)
          .set(currentUser.toJson());

      // updating the friend request status.
      await requests
          .doc(currentUser.uid)
          .collection("userRequests")
          .doc(reqSender.uid)
          .update({"existsInFriends": true});
    } catch (e) {
      rethrow;
    }
  }

  // Stream of friends requests for this specific user.
  Stream<List<CustomUser?>> getFriendRequests() async* {
    List<CustomUser?> requestsList = [];
    try {
      var reqStream =
          requests.doc(currentUser.uid).collection("userRequests").snapshots();

      await for (var snap in reqStream) {
        CustomUser cUser;
        List<CustomUser> tempList = [];
        for (var doc in snap.docs) {
          final reqJson = doc.data();
          // checking if current doc that's in request collection
          // also exists in friends collection
          final docFromFriends = await friends
              .doc(currentUser.uid)
              .collection("userFriends")
              .doc(doc.id)
              .get();

          if (docFromFriends.exists) {
            cUser = CustomUser.fromJson(json: reqJson, exists: true);
          } else {
            cUser = CustomUser.fromJson(json: reqJson);
          }

          tempList.add(cUser);
        }
        requestsList = tempList;
        yield requestsList;
      }
    } catch (e) {
      rethrow;
    }
  }

  // sends a request to the specified user
  Future<bool> sendRequest(String name) async {
    try {
      // regex has two matches
      // 1. everything before the '#'
      // 2. everything after the '#'
      RegExp exp = RegExp(r"[a-zA-Z0-9_\-@.! ]+");
      Iterable<RegExpMatch> match = exp.allMatches(name);
      final dispName = match.toList()[0].group(0).toString();
      final tag = "#" + match.toList()[1].group(0).toString();

      final query = await users
          .where("displayName", isEqualTo: dispName)
          .where("tag", isEqualTo: tag)
          .get();

      final rawData = query.docs[0].data() as Map<String, dynamic>;
      final friendReqReceiver = CustomUser.fromJson(json: rawData);

      final isAlreadyFriend = await friends
          .doc(currentUser.uid)
          .collection("userFriends")
          .doc(friendReqReceiver.uid)
          .get();

      if (isAlreadyFriend.exists) {
        return false;
      }

      if (friendReqReceiver.uid == currentUser.uid) {
        return false;
      }

      await requests
          .doc(friendReqReceiver.uid)
          .collection("userRequests")
          .doc(currentUser.uid)
          .set(currentUser.toJson());

      return true;
    } catch (e) {
      e as Error;
      e.stackTrace;
      return false;
      // rethrow;
    }
  }

  //////// Testing ////////
}
