import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../model/trello_user.dart';
import '../service/onboarding_service.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingService onboardingService;
  final Dio dio;

  OnboardingCubit(
    this.onboardingService,
    this.dio,
  ) : super(OnboardingLoading());

  @override
  Future<void> close() {
    usernameStreamController.close();
    usernameChannel.dispose();
    return super.close();
  }

  final usernameStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  final usernameChannel = io.io(
    'http://localhost:3000/users',
    io.OptionBuilder()
        .disableAutoConnect()
        .setTransports(['websocket']).build(),
  );

  Future<void> authenticateWithGoogle() async {
    try {
      emit(OnboardingLoading());
      final user = await onboardingService.authenticateWithGoogle();
      final res = await dio.get('/users/${user.user!.email}');
      if (res.data == null ||
          (res.data != null && res.data.toString().isEmpty)) {
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
        final trelloUser = TrelloUser.fromJson(res.data);
        emit(
          OnboardingSuccess(
            trelloUser,
            isNewUser:
                trelloUser.createdAt!.isAtSameMomentAs(trelloUser.updatedAt!),
          ),
        );
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> verifyUsername(String username) async {
    try {
      usernameChannel.emit(
        "username",
        {
          "username": username,
        },
      );
      usernameChannel.on(
        'username',
        (event) {
          if (event['error'] == true) {
            usernameStreamController.addError(event['message']);
            return;
          }
          usernameStreamController.add(event);
        },
      );
    } catch (e) {
      usernameStreamController.addError(e);
      emit(OnboardingError(e.toString()));
    }
  }

  void saveSession(TrelloUser user) async {
    await onboardingService.saveSession(user);
  }

  void tryConnectingToServer() async {
    usernameChannel.connect();
    usernameStreamController.add(
      {
        "error": false,
        "message": "Connected to server!",
      },
    );
  }

  Future<TrelloUser?> getSession() async {
    final user = await onboardingService.getSession();
    emit(
      user != null
          ? OnboardingSuccess(
              user,
              isNewUser: user.updatedAt!.isAtSameMomentAs(user.createdAt!),
            )
          : const OnboardingError(
              "No active session",
            ),
    );
    return user;
  }

  void updateProfile(
    TrelloUser user, {
    String? username,
    String? avatarUrl,
  }) async {
    onboardingService.updateProfile(
      user,
      username: username,
      avatarUrl: avatarUrl,
    );
  }
}
