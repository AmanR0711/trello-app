import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Conditional imports for web and native, 
// TODO: for now we will use the web implementation
import 'ui/google_sign_in/web.dart';
    // if(dart.library.io) 'ui/google_sign_in/native.dart'
    // if (dart.library.html) 'ui/google_sign_in/google_sign_in_button_web.dart';

import '../common/ui/loading_dialog.dart';
import '../common/ui/trello_message_dialog.dart';
import 'bloc/onboarding_cubit.dart';
import 'bloc/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (c, s) {
        if (s is OnboardingLoading) {
          showDialog(
            context: c,
            builder: (cc) => const LoadingDialog(),
          );
        } else if (s is OnboardingError) {
          Navigator.of(c).pop();
          showDialog(
            context: c,
            builder: (cc) => TrelloMessageDialog(
              title: "An Error Occurred!",
              message: s.message,
            ),
          );
          print("Error: ${s.message}");
        } else if (s is OnboardingSuccess) {
          Navigator.of(c).pop();
          showDialog(
            context: c,
            builder: (cc) => TrelloMessageDialog(
              title: "Success!",
              message: s.isNewUser
                  ? "Welcome to Trello!"
                  : "Welcome back, ${s.user.username}!",
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF862626),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/onboarding.png",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.45),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.30,
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.85,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.dashboard,
                                size: 96,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "T.R.E.L.L.O",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tasks Rearranged, Everything Looks Lovely & Organized",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Divider(),
                          ),
                          const SizedBox(height: 12),
                          const GoogleSignInButton(
                            // onboardingCubit:
                            //     BlocProvider.of<OnboardingCubit>(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
