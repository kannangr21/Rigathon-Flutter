import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> loginWithGoogle() async {
    await _auth.signOut(); //signing out current user from auth
    await googleSignIn
        .signOut(); //to bring up account selection everytime instead of logging in to the last used account
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential _credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth.signInWithCredential(_credential);
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> googleSignOut() async {
    print("google sign out?");
    await _auth.signOut();
    await googleSignIn.signOut();
  }
}
