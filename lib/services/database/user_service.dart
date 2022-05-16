// ignore_for_file: unused_field
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/chatroom.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/database_service.dart';
import 'package:streaming/services/shared_preferences.dart';

class UserService extends DatabaseService {
  /// DECLARATIONS ///
  final StreamController<CustomUser?> _cusUserController =
      StreamController.broadcast();
  late StreamSubscription _subscription;
  late StreamSubscription _authSubscription;

  StreamController get cusUserController => _cusUserController;
  CustomUser get currentUser => DatabaseService.user;

  /// INIT ///

  // constructor.
  UserService() {
    addStream();
  }

  // this has to be called on auth so that the if the user changes
  // the stream should also be update. Without this,
  // we keep listening to changes of the previous user.
  @override
  addStream() {
    _subscription = getCurrUserFromDB().listen((event) {
      return _cusUserController.add(event);
    });
  }

  // cleans up the data from the stream and cancels it.
  // use it when you logout and don't want to keep listening.
  // this can help in getting rid of old data being used when user logs in.
  @override
  Future<void> cleanupStream() async {
    await _subscription.cancel();
    await _cusUserController.stream.drain();
  }

  /// METHODS ///

  // get all the users
  // Future<List<CustomUser>?> getOtherUsers() async {
  //   List<CustomUser> userList = [];
  //   // access the users collection
  //   final rawUsers = await users.get();

  //   // check for each user in Users collection
  //   // is available in the Contacts collection.
  //   for (var user in rawUsers.docs) {
  //     final userInContacts = await friends
  //         .doc(currentUser.uid)
  //         .collection("userFriends")
  //         .doc(user.id)
  //         .get();

  //     final json = user.data() as Map<String, dynamic>;
  //     CustomUser cUser;

  //     // if available set its exists Property to true and return it.
  //     if (userInContacts.exists) {
  //       cUser = CustomUser.fromJson(json: json, exists: true);
  //       // if not then simply return the user.
  //     } else {
  //       cUser = CustomUser.fromJson(json: json);
  //     }

  //     // add the users to list except the current one.
  //     if (cUser.uid != currentUser.uid) {
  //       userList.add(cUser);
  //     }
  //   }
  //   // return the list.
  //   return userList;
  // }

  // update the user
  Future<bool> updateUserData({
    String? displayName,
    String? status,
  }) async {
    bool success = false;
    try {
      // if something doesn't update change current user back to DBService.user.

      // updating user data in users collection
      await users.doc(currentUser.uid).update({
        "displayName": displayName ?? DatabaseService.user.displayName,
        "status": status ?? DatabaseService.user.status
      });

      /// UPDATING OTHER COLLECTION ///
      _updateUserInOtherCollections(displayName: displayName, status: status);
    } catch (e) {
      rethrow;
    }
    return success;
  }

  // updating user in friends and room collections.
  _updateUserInOtherCollections({
    String? displayName,
    String? status,
  }) async {
    /// UPDATING THE USERDATA IN FRIENDS COLLECTION ///
    friends.get().then((value) {
      // getting each user from the friends collections
      for (var friendDoc in value.docs) {
        // querying if the users have the currentUser as their friend.
        friends
            .doc(friendDoc.id)
            .collection("userFriends")
            .where("uid", isEqualTo: currentUser.uid)
            .get()
            .then((value) {
          // for document where currentUser is their friend
          // currentUsers data is updated.
          for (var currUser in value.docs) {
            currUser.reference.update({
              "displayName": displayName ?? DatabaseService.user.displayName,
              "status": status ?? DatabaseService.user.status
            });
          }
        });
      }
    });

    /// UPDATING THE USERDATA IN CHATROOM COLLECTION ///
    rooms
        .where("participentIds", arrayContains: currentUser.uid)
        .get()
        .then((roomsContainerUser) {
      for (var room in roomsContainerUser.docs) {
        final roomJson = room.data() as Map<String, dynamic>;
        List participentsList = roomJson["participents"] as List;
        final newParticipentList = participentsList.map((participent) {
          if (participent["uid"] == currentUser.uid) {
            participent["displayName"] =
                displayName ?? DatabaseService.user.displayName;
            participent["status"] = status ?? DatabaseService.user.status;
          }
          return participent;
        }).toList();
        rooms.doc(room.id).update({"participents": newParticipentList});
      }
    });
  }

  // gets the user from database and
  // assigns it to the variable user via setUser().
  Stream<CustomUser?> getCurrUserFromDB() async* {
    try {
      CustomUser? currUser;

      await for (DocumentSnapshot<Object?> event
          in users.doc(DatabaseService.user.uid).snapshots()) {
        if (event.data() != null) {
          final jsonMap = event.data() as Map<String, dynamic>;
          currUser = CustomUser.fromJson(json: jsonMap);
          // with this I am able to avoid the user being null.
          setUser(currUser);
          CustomPreferences.setCurrUser(currUser);
        }
        yield currUser;
      }
    } catch (e) {
      rethrow;
    }
  }
}
