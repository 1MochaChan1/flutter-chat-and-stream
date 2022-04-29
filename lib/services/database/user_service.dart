// ignore_for_file: unused_field
import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/database/database_service.dart';
import 'package:streaming/services/shared_preferences.dart';

class UserService extends DatabaseService {
  /// DECLARATIONS ///
  final StreamController<CustomUser?> _cusUserController =
      StreamController.broadcast(onCancel: () => log("Stream Cancelled"));
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
  Future<List<CustomUser>?> getOtherUsers() async {
    List<CustomUser> userList = [];
    // access the users collection
    final rawUsers = await users.get();

    // check for each user in Users collection
    // is available in the Contacts collection.
    for (var user in rawUsers.docs) {
      final userInContacts = await friends
          .doc(currentUser.uid)
          .collection("userFriends")
          .doc(user.id)
          .get();

      final json = user.data() as Map<String, dynamic>;
      CustomUser cUser;

      // if available set its exists Property to true and return it.
      if (userInContacts.exists) {
        cUser = CustomUser.fromJson(json: json, exists: true);
        // if not then simply return the user.
      } else {
        cUser = CustomUser.fromJson(json: json);
      }

      // add the users to list except the current one.
      if (cUser.uid != currentUser.uid) {
        userList.add(cUser);
      }
    }
    // return the list.
    return userList;
  }

  // update the user
  Future<bool> updateUserData({
    String? displayName,
    String? status,
  }) async {
    bool success = false;
    try {
      await users.doc(DatabaseService.user.uid).update({
        "displayName": displayName ?? DatabaseService.user.displayName,
        "status": status ?? DatabaseService.user.status
      });
    } catch (e) {
      rethrow;
    }
    return success;
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
