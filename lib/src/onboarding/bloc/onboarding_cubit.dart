import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/trello_user.dart';
import '../service/onboarding_service.dart';
import 'onboarding_state.dart';

// TODO: Need server to complete this
class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingService onboardingService;
  final Dio dio;

  OnboardingCubit(
    this.onboardingService,
    this.dio,
  ) : super(OnboardingLoading());

  Future<void> authenticateWithGoogle() async {
    try {
      emit(OnboardingLoading());
      final user = await onboardingService.authenticateWithGoogle();
      if (user.user == null) {
        // Temporary, will be replaced with server response
        final res = await dio.post(
          '/users/create',
          data: {
            'email': user.user!.email,
            'username': user.user!.displayName,
            'avatarUrl': user.user!.photoURL,
            'theme': "Light",
          },
        );
        final trelloUser = TrelloUser.fromJson(res.data);
        emit(
          OnboardingSuccess(
            trelloUser,
            isNewUser: trelloUser.createdAt == trelloUser.updatedAt,
          ),
        );
      } else {
        final res = await dio.get('/users/${user.user!.email}');
        final trelloUser = TrelloUser.fromJson(res.data);
        emit(
          OnboardingSuccess(
            trelloUser,
            isNewUser: trelloUser.createdAt == trelloUser.updatedAt,
          ),
        );
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  // Web signin uses `renderButton`
  Stream<User?> authWithGoogleWeb() async* {
    yield* onboardingService.authStateStream;
  }
}
