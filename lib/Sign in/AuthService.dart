import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          print("Google Sign-In Successful: ${user.displayName}");
        } else {
          print("Google Sign-In Failed");
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      // Handle the error gracefully (e.g., show an error message to the user).
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print("Sign out successful");
    } catch (e) {
      print("Error signing out: $e");
      // Handle the error gracefully (e.g., show an error message to the user).
    }
  }
}
