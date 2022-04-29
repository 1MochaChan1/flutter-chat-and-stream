// ignore_for_file: prefer_final_fields, unused_field

import 'dart:async';
import 'dart:developer';

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

  Future<void> addToFriends(CustomUser newContact) async {
    try {
      await friends
          .doc(currentUser.uid)
          .collection("userFriends")
          .doc(newContact.uid)
          .set(newContact.toJson());
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
      reqStream.listen((event) {
        log(event.docs.length.toString());
      });
      await for (var snap in reqStream) {
        for (var doc in snap.docs) {
          final reqJson = doc.data() as Map<String, dynamic>;
          CustomUser cUser = CustomUser.fromJson(json: reqJson);
          requestsList.add(cUser);
        }
        yield requestsList;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendRequest(String name) async {
    try {
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
      await requests
          .doc(friendReqReceiver.uid)
          .collection("userRequests")
          .doc(currentUser.uid)
          .set(currentUser.toJson());

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
