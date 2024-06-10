import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

// import '../onboarding_screen.dart';
import '../bloc/onboarding_cubit.dart';
import 'username_selection_dialog.dart';

class OnboardingPages extends StatelessWidget {
  const OnboardingPages({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showSkipButton: false,
      globalBackgroundColor: Colors.grey.shade200,
      dotsFlex: 2,
      initialPage: 0,
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.amber,
      ),
      // TODO: onDone should go to home screen with boards and stuff
      onDone: () async {
        bool? success = await showDialog(
          context: context,
          builder: (_) => BlocProvider(
            create: (cc) => OnboardingCubit(
              cc.read(),
              cc.read(),
            ),
            child: const UsernameSelectionDialog(),
          ),
        );
        if (success != null && success) {
          context.pushReplacement('/');
        }
      },
      done: const Text(
        "Let's Go!",
        style: TextStyle(color: Colors.white),
      ),
      next: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.shade900,
      ),
      back: Icon(
        Icons.arrow_back_ios,
        color: Colors.grey.shade900,
      ),
      doneStyle: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      backStyle: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      nextStyle: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      showBackButton: true,
      showNextButton: true,
      pages: [
        PageViewModel(
          titleWidget: Text(
            "Organize Projects",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          body:
              "Tasks Rearranged: Simplify your workflow by organizing projects into boards, breaking them down into lists, and filling them with tasks. Keep everything structured and easy to navigate.",
          image: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 48,
            child: Icon(
              Icons.view_list_outlined,
              color: Colors.blue,
              size: 64,
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Text(
            "Sync across Devices",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          body:
              "Everything Looks Lovely: Enjoy seamless synchronization on any device. Access your projects from the web, Android/iOS, or desktop, ensuring your work is always up-to-date.",
          image: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 48,
            child: Icon(
              Icons.cloud_done_rounded,
              color: Colors.green,
              size: 64,
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Text(
            "Collaborate in Real-Time",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          body:
              "Lovely and Organized: Collaborate effortlessly with your team. Share boards, assign tasks, and work together in real-time to keep your projects moving forward smoothly.",
          image: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 48,
            child: Icon(
              Icons.group_add_rounded,
              color: Colors.amber,
              size: 64,
            ),
          ),
        ),
      ],
    );
  }
}
