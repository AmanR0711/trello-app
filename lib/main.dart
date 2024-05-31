import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'src/onboarding/bloc/onboarding_cubit.dart';
import 'src/onboarding/onboarding_screen.dart';
import 'src/onboarding/service/onboarding_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GoogleSignIn>(
          create: (c) => GoogleSignIn(
            scopes: ['email'],
            clientId:
                "255665597270-0f8kspfi8fcr6bn9dn763044mkoktbgj.apps.googleusercontent.com",
          ),
        ),
        RepositoryProvider.value(
          value: FirebaseAuth.instance,
        ),
        RepositoryProvider<OnboardingService>(
          create: (c) => OnboardingService(
            googleSignInProvider: c.read(),
            auth: c.read(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'AlbertSans',
        ),
        home: BlocProvider(
          create: (c) => OnboardingCubit(
            c.read(),
          ),
          child: const OnboardingScreen(),
        ),
      ),
    );
  }
}
