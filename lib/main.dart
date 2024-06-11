import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';
import 'src/board/board_screen.dart';
import 'src/board/ui/create_board_form.dart';
import 'src/board/ui/create_list_form.dart';
import 'src/common/data/themes.dart';
import 'src/common/extra/dialog_route.dart';
import 'src/dashboard/cubit/dashboard_cubit.dart';
import 'src/dashboard/dashboard_screen.dart';

import 'src/dashboard/service/dashboard_service.dart';
import 'src/onboarding/bloc/onboarding_state.dart';
import 'src/onboarding/bloc/onboarding_cubit.dart';
import 'src/onboarding/model/trello_user.dart';
import 'src/onboarding/onboarding_screen.dart';
import 'src/onboarding/service/onboarding_service.dart';
import 'src/onboarding/ui/onboarding_pages.dart';
import 'src/profile/cubit/profile_cubit.dart';
import 'src/profile/profile_screen.dart';
import 'src/profile/service/profile_service.dart';

void main() async {
  // To store user credentials
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  runApp(
    MultiRepositoryProvider(
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
        RepositoryProvider(
          create: (c) => ProfileService(
            c.read(),
            c.read(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
        path: '/profile',
        pageBuilder: (_, s) => DialogPage(
          builder: (__) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (c) => ProfileCubit(c.read()),
              ),
              BlocProvider(
                create: (c) => OnboardingCubit(c.read(), c.read()),
              ),
            ],
            child: const ProfileScreen(),
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
          if (s.extra != null) {
            final user = s.extra as TrelloUser;
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
                  child: DashboardScreen(user),
                ),
              );
            }
          } else {
            return const MaterialPage(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      GoRoute(
        path: '/board',
        builder: (_, __) => Container(),
        routes: [
          GoRoute(
            path: 'new',
            pageBuilder: (c, s) => MaterialPage(
              child: BlocProvider(
                create: (cc) => DashboardCubit(
                  cc.read(),
                  cc.read(),
                ),
                child: const CreateBoardForm(),
              ),
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            path: ':boardId',
            pageBuilder: (c, s) {
              final boardId = s.pathParameters['boardId'];
              return MaterialPage(
                child: BlocProvider(
                  create: (cc) => DashboardCubit(cc.read(), cc.read()),
                  child: BoardScreen(boardId!),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'list/new',
                pageBuilder: (c, s) {
                  final boardId = s.pathParameters['boardId'];
                  if (boardId != null) {
                    return MaterialPage(
                      child: BlocProvider(
                        create: (c) => DashboardCubit(
                          c.read(),
                          c.read(),
                        ),
                        child: CreateListForm(boardId),
                      ),
                      fullscreenDialog: true,
                    );
                  }
                  return MaterialPage(child: Container());
                },
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (c, s) {
      if (s.fullPath == '/board') {
        return '/';
      } else if (s.fullPath == '/dashboard' && s.extra == null) {
        return '/';
      }
      return null;
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      bloc: OnboardingCubit(context.read(), context.read()),
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: state is OnboardingSuccess
              ? AppThemes[(state.user.theme)]
              : ThemeData.light(),
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<OnboardingCubit>(context);
    return FutureBuilder(
      future: cubit.getSession(),
      builder: (context, snapshot) {
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
              context.go('/dashboard', extra: state.user);
            } else if (state is OnboardingError) {
              context.go('/onboarding');
            }
          },
        );
      },
    );
  }
}
