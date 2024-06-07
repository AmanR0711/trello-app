import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'src/board/ui/create_board_form.dart';
import 'src/common/ui/trello_confirm_dialog.dart';
import 'src/dashboard/cubit/dashboard_cubit.dart';
import 'src/dashboard/dashboard_screen.dart';

import 'src/dashboard/service/dashboard_service.dart';
import 'src/onboarding/bloc/onboarding_state.dart';
import 'src/onboarding/bloc/onboarding_cubit.dart';
import 'src/onboarding/onboarding_screen.dart';
import 'src/onboarding/service/onboarding_service.dart';
import 'src/onboarding/ui/onboarding_pages.dart';

void main() async {
  // To store user credentials
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
            child: const Home(),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
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
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (c) => DashboardCubit(c.read(), c.read()),
                  ),
                  BlocProvider(
                    create: (c) => OnboardingCubit(c.read(), c.read()),
                  ),
                ],
                child: const DashboardScreen(),
              ),
            );
          }
        },
      ),
      GoRoute(
        path: '/board/new',
        onExit: (c, s) async {
          final res = await showDialog<bool>(
            context: c,
            builder: (cc) => const TrelloConfirmDialog(
              message: "Discard your current changes?",
            ),
          );
          return res ?? false;
        },
        pageBuilder: (c, s) => const MaterialPage(
          child: CreateBoardForm(),
          fullscreenDialog: true,
        ),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // HTTP client
        RepositoryProvider.value(value: dioClient),
        // Firebase
        RepositoryProvider.value(value: FirebaseAuth.instance),
        // For storing user credentials
        RepositoryProvider(
          create: (_) => const FlutterSecureStorage(),
        ),
        RepositoryProvider<GoogleSignIn>(
          create: (c) => GoogleSignIn(
            scopes: ['email'],
            clientId:
                "255665597270-0f8kspfi8fcr6bn9dn763044mkoktbgj.apps.googleusercontent.com",
          ),
        ),
        RepositoryProvider<OnboardingService>(
          create: (c) => OnboardingService(
            googleSignInProvider: c.read(),
            auth: c.read(),
            fss: c.read(),
            dio: c.read(),
          ),
        ),
        RepositoryProvider<DashboardService>(
          create: (c) => DashboardService(
            c.read(),
            c.read(),
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<OnboardingCubit>(context);
    final user = cubit.getSession();
    return BlocListener<OnboardingCubit, OnboardingState>(
      bloc: cubit,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      listener: (context, state) async {
        if (state is OnboardingLoading) {
          cubit.getSession();
        } else if (state is OnboardingSuccess) {
          context.go('/dashboard', extra: (await user)!);
        } else if (state is OnboardingError) {
          context.go('/onboarding');
        }
      },
    );
  }
}
