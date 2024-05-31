import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  Future<User?> authenticateWithGoogle() async {
    try {
      GoogleSignInAccount? user;
      user = await googleSignInProvider.signIn();
      final details = await user!.authentication;
      final creds = GoogleAuthProvider.credential(
        accessToken: details.accessToken,
        idToken: details.idToken,
      );
      final userCreds = await auth.signInWithCredential(creds);
      return userCreds.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
