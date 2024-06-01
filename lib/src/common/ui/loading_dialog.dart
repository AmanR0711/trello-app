import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Loading"),
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 12),
          Text("Please wait..."),
        ],
      ),
    );
  }
}
