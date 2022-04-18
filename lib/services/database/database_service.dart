import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/shared_preferences.dart';

class DatabaseService {
  CustomUser? _user;
  CustomUser get user => _user!;

  // if the currentUser isn't stored in the sharedPreference
  // this method is called at the time of authentication.
  void setUser(CustomUser customUser) {
    _user = customUser;
  }

  // in combination with this empty constrcutor and setUser
  // we can assign the customUser and use it.
  DatabaseService();

  // named constructor that can be called
  // if the currentUser is stored in sharedPreference.
  DatabaseService._init(CustomUser cusUser) {
    _user = cusUser;
  }

  // if the currentUser is stored in the sharedPreference
  // we can use this static function as a constructor
  // this is used because async can't be used
  static Future<DatabaseService?> init() async {
    CustomUser? cusUser = await CustomPreferences.getCurrUser();
    if (cusUser == null) return null;
    return DatabaseService._init(cusUser);
  }

  // collection/table of users.
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  // update the user
  Future<bool> updateUserData({required String name}) async {
    bool success = false;

    try {
      await users.doc(user.uid).set({"name": name});
    } catch (e) {
      rethrow;
    }
    return success;
  }
}
