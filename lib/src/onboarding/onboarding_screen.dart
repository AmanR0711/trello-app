import 'package:app/src/onboarding/ui/google_sign_in_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        const Divider(),
                        const SizedBox(height: 12),
                        const GoogleSignInButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
