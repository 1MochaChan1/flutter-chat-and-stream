// ignore_for_file: prefer_final_fields
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/shared_preferences.dart';

class DatabaseService {
  /// DECLARATION ///
  StreamController<CustomUser?> _cusUserController = StreamController.broadcast(
    onCancel: () => log("Stream Cancelled"),
  );
  StreamController<CustomUser?> get cusUserController => _cusUserController;

  // ignore: unused_field
  late StreamSubscription _subscription;

  CustomUser? _user;

  /// METHODS ///

  // regular getter
  CustomUser get user => _user!;

  // regular setter
  void setUser(CustomUser cusUser) async {
    _user = cusUser;
  }

  // created a subscription and adding events
  // without it I was having trouble with the stream
  // always in a state of adding another stream.
  Future<void> addStream({CustomUser? cusUser}) async {
    _subscription = getCurrUserFromDB().listen((event) {
      return _cusUserController.add(event);
    });
  }

  /// INIT ///

  // in combination with this empty constrcutor and setInitUser
  // we can assign the customUser and use it.
  // this is used to instantiate and setInitUser is used to
  // assign the customUser to _user.
  DatabaseService() {
    addStream();
  }

  // if the currentUser isn't stored in the sharedPreference
  // this method is called at the time of authentication.
  Future setInitUser(CustomUser customUser) async {
    // however this customUser doesn't have our custom properties
    // just a firebaseUser mapped to customUser.
    _user = customUser;
    await checkNewUser(customUser);
  }

  // if the currentUser is stored in sharedPreference.
  // this named constructor that can be called
  DatabaseService._init(CustomUser cusUser) {
    addStream();
    _user = cusUser;
  }

  // if the currentUser is stored in the sharedPreference
  // we can use this static function as a constructor
  // this is used because async can't be used in constructor.
  static Future<DatabaseService?> init() async {
    CustomUser? cusUser = await CustomPreferences.getCurrUser();
    if (cusUser == null) return null;
    return DatabaseService._init(cusUser);
  }

  /// OPERATIONS ///

  // collection/table of users.
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  // check if this user is new
  // yes: creates a new user in collection and gets it.
  // no: gets the user from db
  Future<CustomUser> checkNewUser(CustomUser? cusUser) async {
    try {
      _user = cusUser ?? user;
      final fAuthUser = await users.doc(user.uid).get();
      CustomUser newUser;
      if (!fAuthUser.exists) {
        newUser = await createNewUser();
        _user = newUser;
      } else {
        // newUser = await getCurrUserFromDB();
        // _user = newUser;

        final fsUser = await users.doc(_user?.uid).get();
        final jsonMap = fsUser.data() as Map<String, dynamic>;

        newUser = CustomUser.fromJson(jsonMap);
        _user = newUser;
        CustomPreferences.setCurrUser(_user);
      }
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // creates a new user if not exists and
  // uploads it to firestore.
  Future<CustomUser> createNewUser() async {
    try {
      CustomUser newUser = CustomUser(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        email: user.email,
      );
      await users.doc(user.uid).set(newUser.toJson());
      _user = newUser;
      CustomPreferences.setCurrUser(_user);

      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // gets the user from database and
  // assigns it to the variable _user.
  Stream<CustomUser?> getCurrUserFromDB() async* {
    try {
      CustomUser? currUser;

      if (_user != null) {
        await for (DocumentSnapshot<Object?> event
            in users.doc(user.uid).snapshots()) {
          if (event.data() != null) {
            final jsonMap = event.data() as Map<String, dynamic>;
            currUser = CustomUser.fromJson(jsonMap);
            _user = currUser;
            CustomPreferences.setCurrUser(_user);
          }

          yield currUser;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // update the user
  Future<bool> updateUserData({
    String? displayName,
    String? status,
  }) async {
    bool success = false;
    try {
      await users.doc(user.uid).update({
        "displayName": displayName ?? user.displayName,
        "status": status ?? user.status
      });
    } catch (e) {
      rethrow;
    }
    return success;
  }
}
