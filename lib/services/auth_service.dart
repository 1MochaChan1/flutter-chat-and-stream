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

  // constructor for authService.
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _fAuth = firebaseAuth ?? FirebaseAuth.instance,
        _gSignIn = googleSignIn ?? GoogleSignIn();

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

  // stream that is made from another stream
  // this returns a CustomUser object instead of User.
  Stream<User?> get onAuthStateChanged async* {
    User? fbUser;
    await for (var user in _fAuth.authStateChanges()) {
      _userFromFirebase(user);
      fbUser = user;
      yield user;
    }
    yield fbUser;
  }

  // google Sign In
  Future<CustomUser?> googleSignIn() async {
    final GoogleSignInAccount? _user = await _gSignIn.signIn();
    if (_user == null) return null;

    final GoogleSignInAuthentication? gAuth = await _user.authentication;

    final credential = GoogleAuthProvider.credential(
        idToken: gAuth?.idToken, accessToken: gAuth?.accessToken);

    UserCredential userCredential =
        await _fAuth.signInWithCredential(credential);
    return _userFromFirebase(userCredential.user);
  }

  // sign out
  Future signOut() async {
    // will use enum here.
    bool isGoogleSignedIn = await _gSignIn.isSignedIn();
    if (isGoogleSignedIn) {
      await GoogleSignIn().disconnect();
      CustomPreferences.setCurrUser(null);
    }

    _fAuth.signOut();
  }
}
