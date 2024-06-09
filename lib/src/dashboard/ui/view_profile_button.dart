import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../onboarding/model/trello_user.dart';

class ViewProfileButton extends StatelessWidget {
  final TrelloUser user;
  const ViewProfileButton(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.amber,
      radius: 18.0,
      child: InkWell(
        onTap: () => context.push('/profile', extra: user),
        child: CircleAvatar(
          radius: 16.0,
          foregroundImage: NetworkImage(user.avatarUrl),
        ),
      ),
    );
  }
}
