import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../onboarding/bloc/onboarding_cubit.dart';
import '../../onboarding/model/trello_user.dart';

class ViewProfileButton extends StatelessWidget {
  const ViewProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final oc = BlocProvider.of<OnboardingCubit>(context);
    return FutureBuilder(
      future: oc.getSession(),
      builder: (c, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data as TrelloUser;
          return CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            radius: 18.0,
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 16.0,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
