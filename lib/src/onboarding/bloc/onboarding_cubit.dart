import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/trello_user.dart';
import '../service/onboarding_service.dart';
import 'onboarding_state.dart';

// TODO: Need server to complete this
class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingService onboardingService;

  OnboardingCubit(this.onboardingService) : super(OnboardingLoading());

  Future<void> authenticateWithGoogle() async {
    try {
      emit(OnboardingLoading());
      final user = await onboardingService.authenticateWithGoogle();
      if (user != null) {
        // Temporary, will be replaced with server response
        final trelloUser = TrelloUser(
          username: "",
          email: user.email!,
          avatarUrl: user.photoURL!,
        );
        emit(OnboardingSuccess(trelloUser, isNewUser: true));
      } else {
        emit(const OnboardingError('Failed to authenticate with Google'));
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}
