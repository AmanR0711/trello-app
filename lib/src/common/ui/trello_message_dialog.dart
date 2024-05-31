import 'package:flutter/material.dart';

class TrelloMessageDialog extends StatelessWidget {
  final String title, message;

  const TrelloMessageDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(message)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
