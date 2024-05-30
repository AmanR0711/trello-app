import 'package:equatable/equatable.dart';

import '../model/trello_user.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

/// The loading state of the onboarding process.
/// The user has just authenticated with Google OAuth,
/// and is waiting to see a response from the server
class OnboardingLoading extends OnboardingState {}

/// The success state of the onboarding process.
/// The user has successfully authenticated with Google OAuth,
/// and the server has returned the user data.
/// The user could be new or existing, indicated with a boolean flag.
/// If the user is new, the user will be redirected to the onboarding screen.
/// If the user is existing, the user will be redirected to the home screen.
class OnboardingSuccess extends OnboardingState {
  final TrelloUser user;
  final bool isNewUser;

  const OnboardingSuccess(
    this.user, {
    required this.isNewUser,
  });

  @override
  List<Object> get props => [user, isNewUser];
}

/// The error state of the onboarding process.
/// The user has failed to authenticate with Google OAuth,
/// or the server has returned an error.
/// The error message is displayed to the user, and they may retry the process.
class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}
