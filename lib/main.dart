import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'src/onboarding/bloc/onboarding_cubit.dart';
import 'src/onboarding/onboarding_screen.dart';
import 'src/onboarding/service/onboarding_service.dart';
import 'src/onboarding/ui/onboarding_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final dioClient = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api',
    ),
  )..interceptors.add(
      LogInterceptor(
        responseBody: true,
        error: true,
        requestBody: true,
      ),
    );

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (c, s) => MaterialPage(
          child: BlocProvider(
            create: (c) => OnboardingCubit(c.read(), c.read()),
            child: const OnboardingScreen(),
          ),
        ),
      ),
      // Home page
      GoRoute(
        path: '/dashboard',
        pageBuilder: (c, s) {
          if (s.uri.queryParameters['newUser'] == "true") {
            return MaterialPage(
              child: BlocProvider(
                create: (cc) => OnboardingCubit(
                  cc.read(),
                  cc.read(),
                ),
                child: const OnboardingPages(),
              ),
            );
          } else {
            return MaterialPage(
              child: Container(), //DashboardScreen(),
            );
          }
        },
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dioClient),
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
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'AlbertSans',
        ),
      ),
    );
  }
}
