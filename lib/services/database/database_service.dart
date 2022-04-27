// ignore_for_file: prefer_final_fields, unused_field
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/shared_preferences.dart';

class DatabaseService {
  /// DECLARATION ///
  FirebaseFirestore _fsInstance = FirebaseFirestore.instance;
  static CustomUser? _user;

  /// METHODS ///
  // regular getter
  static CustomUser get user => _user!;
  // StreamController<CustomUser?> get cusUserController => _cusUserController;

  // regular setter
  void setUser(CustomUser cusUser) async {
    _user = cusUser;
  }

  /// INIT ///

  // in combination with this empty constrcutor and setInitUser
  // we can assign the customUser and use it.
  // this is used to instantiate and setInitUser is used to
  // assign the customUser to _user.
  DatabaseService();

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
  CollectionReference contacts =
      FirebaseFirestore.instance.collection("Contacts");

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
        final fsUser = await users.doc(_user?.uid).get();
        final jsonMap = fsUser.data() as Map<String, dynamic>;

        newUser = CustomUser.fromJson(json: jsonMap);
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
}
