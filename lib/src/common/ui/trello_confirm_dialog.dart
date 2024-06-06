import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrelloConfirmDialog extends StatelessWidget {
  final String message;
  const TrelloConfirmDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm?"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => GoRouter.of(context).pop(false),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).pop(true),
          child: const Text("Yes"),
        ),
      ],
    );
  }
}