import 'package:flutter/material.dart';

import 'stub.dart';

Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return _GoogleSignInButton(onPressed: onPressed);
}

class _GoogleSignInButton extends StatelessWidget {
  final HandleSignInFn? onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith(
            (_) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: WidgetStateColor.resolveWith(
            (_) => Colors.grey.shade300,
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (_) => BorderSide(
              color: Colors.grey.shade500,
              width: 2.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('assets/google.png'),
                height: 60,
                width: 60,
              ),
              const SizedBox(width: 4),
              Text(
                "Continue with Google",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
