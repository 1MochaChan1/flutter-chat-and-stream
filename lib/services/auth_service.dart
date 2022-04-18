import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming/models/custom_user.dart';
import 'package:streaming/services/shared_preferences.dart';

class AuthService {
  final GoogleSignIn _gSignIn;
  final FirebaseAuth _fAuth;

  // getters for user data
  CustomUser? _user;
  CustomUser get user => _user!;

  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _fAuth = firebaseAuth ?? FirebaseAuth.instance,
        _gSignIn = googleSignIn ?? GoogleSignIn();

  CustomUser? _userFromFirebase(User? user) {
    if (user == null) return null;

    _user = CustomUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL);
    CustomPreferences.setCurrUser(_user!);

    return _user;
  }

  Stream<CustomUser?> get onAuthStateChanged async* {
    CustomUser? cusUser;
    await for (var user in _fAuth.authStateChanges()) {
      if (user != null) {
        cusUser = _userFromFirebase(user);
      }
      yield cusUser;
    }
    yield cusUser;
  }

  // Google Sign In
  Future<CustomUser?> googleSignIn() async {
    final GoogleSignInAccount? _user = await _gSignIn.signIn();
    if (_user == null) return null;

    final GoogleSignInAuthentication? gAuth = await _user.authentication;

    final credential = GoogleAuthProvider.credential(
        idToken: gAuth?.idToken, accessToken: gAuth?.accessToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return _userFromFirebase(userCredential.user);
  }

  Future googleSignOut() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }
}
