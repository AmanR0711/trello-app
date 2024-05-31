import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:google_sign_in_web/web_only.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return renderButton();
  }
}