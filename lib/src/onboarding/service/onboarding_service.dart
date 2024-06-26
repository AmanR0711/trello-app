import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles authentication with Google OAuth,
/// creating a new T.R.E.L.L.O user account
/// if the user is new.
///
/// Else it will sign in the user and return the user data.
class OnboardingService {
  final GoogleSignIn googleSignInProvider;
  final FirebaseAuth auth;

  OnboardingService({
    required this.googleSignInProvider,
    required this.auth,
  });

  /// Authenticates the user with Google OAuth.
  /// TODO: Below
  /// If the user is new, it will create a new account.
  /// Else it will sign in the user and return the user data.
  Future<UserCredential> authenticateWithGoogle() async {
    try {
      final user = await googleSignInProvider.signIn();
      final details = await user!.authentication;
      final creds = GoogleAuthProvider.credential(
        accessToken: details.accessToken,
        idToken: details.idToken,
      );
      final userCreds = await auth.signInWithCredential(creds);
      return userCreds;
    } catch (e) {
      print("Loss $e");
      throw Exception(e.toString());
    }
  }

  // Web only
  // Auth state changes
  Stream<User?> get authStateStream => auth.authStateChanges();
}
