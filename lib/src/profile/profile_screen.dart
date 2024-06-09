import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../onboarding/model/trello_user.dart';

class ProfileScreen extends StatefulWidget {
  final TrelloUser user;

  const ProfileScreen(this.user, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(12.0),
      children: [
        Center(
          child: CircleAvatar(
            radius: 52.0,
            backgroundColor: Colors.amber,
            child: CircleAvatar(
              radius: 48.0,
              backgroundImage: NetworkImage(widget.user.avatarUrl),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          widget.user.username,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(widget.user.email, textAlign: TextAlign.center),
        const SizedBox(height: 16.0),
        const SizedBox(height: 16.0),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const WidgetStatePropertyAll(Colors.red),
            ),
            child: const Text('Logout'),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
