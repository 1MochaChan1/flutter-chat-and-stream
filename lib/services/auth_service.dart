import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _gSignIn = GoogleSignIn();

  // Google Sign In
  Future<UserCredential?> googleSignIn() async {
    final GoogleSignInAccount? _user = await _gSignIn.signIn();
    if (_user == null) return null;

    final GoogleSignInAuthentication? gAuth = await _user.authentication;

    final credential = GoogleAuthProvider.credential(
        idToken: gAuth?.idToken, accessToken: gAuth?.accessToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  Future googleSignOut() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }
}
