import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/models/enums.dart';
import 'package:streaming/services/shared_preferences.dart';

class AuthService {
  final StreamController _authStateStreamController =
      StreamController.broadcast();
  late StreamSubscription _streamSubscription;

  StreamController get authStateStreamController => _authStateStreamController;

  addStream() {
    _streamSubscription = onAuthStateChanged.listen((event) {
      _authStateStreamController.add(event);
    });
  }

  cleanupStream() async {
    await _streamSubscription.cancel();
    _authStateStreamController.stream.drain();
  }

  final GoogleSignIn _gSignIn;
  final FirebaseAuth _fAuth;

  // getters for user data
  CustomUser? _user;
  CustomUser get user => _user!;

  // constructor for authService.
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _fAuth = firebaseAuth ?? FirebaseAuth.instance,
        _gSignIn = googleSignIn ?? GoogleSignIn() {
    addStream();
  }

  // 1. converts the User object to CustomUser.
  // 2. called whenever auth change detected.
  // 3. this doesn't hold any significance except for it to be used in my_app.dart
  // as a value of the Stream provider which calls it.
  CustomUser? _userFromFirebase(User? user) {
    if (user == null) return null;

    _user = CustomUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    return _user;
  }

  // returns firebaseUser if changed.
  Stream<User?> get onAuthStateChanged async* {
    User? fbUser;
    await for (var user in _fAuth.authStateChanges()) {
      _userFromFirebase(user);
      fbUser = user;
      yield user;
    }
    yield fbUser;
  }

  // email and password sign in.
  Future<Map<String, dynamic>> emailSignIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return {
        "user": _userFromFirebase(userCredential.user),
        "response": AuthState.success
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return {"user": null, "response": AuthState.noUserFound};
      } else if (e.code == "wrong-password") {
        return {"user": null, "response": AuthState.wrongPassword};
      }
      rethrow;
    }
  }

  // creating a new email/password user.
  Future<AuthState> createNewUser(
      {required String email, required String password}) async {
    try {
      await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return AuthState.emailAlreadyInUse;
      } else if (e.code == "weak-password") {
        return AuthState.weakPassword;
      }
      rethrow;
    }
  }

  // google Sign In
  Future<CustomUser?> googleSignIn() async {
    try {
      final GoogleSignInAccount? _user = await _gSignIn.signIn();
      if (_user == null) return null;

      final GoogleSignInAuthentication? gAuth = await _user.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: gAuth?.idToken, accessToken: gAuth?.accessToken);

      UserCredential userCredential =
          await _fAuth.signInWithCredential(credential);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      rethrow;
    }
  }

  // sign out
  Future signOut() async {
    // will use enum here.
    bool isGoogleSignedIn = await _gSignIn.isSignedIn();
    if (isGoogleSignedIn) {
      await GoogleSignIn().disconnect().catchError((err) async {
        log("Google signout error");
      });
      CustomPreferences.setCurrUser(null);
    }

    _fAuth.signOut();
  }

  /// Test Functions ///

  Future<AuthState> testCreateNewUser(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    try {
      if (email.length < 5) {
        return AuthState.noUserFound;
      } else if (password.length < 5) {
        return AuthState.wrongPassword;
      }
      return AuthState.success;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> testEmailSignIn(
      {required String email, required String password}) async {
    try {
      Map<String, dynamic> resp = {
        "user": CustomUser(uid: "someID"),
        "response": AuthState.success
      };
      return resp;
    } catch (e) {
      rethrow;
    }
  }
}
