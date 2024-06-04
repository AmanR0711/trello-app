import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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

  final usernameChannel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.0.103:3000/users'),
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
            isNewUser: trelloUser.createdAt == trelloUser.updatedAt,
          ),
        );
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Stream verifyUsername(String username) async* {
    try {
      print("Username: " + username);
      usernameChannel.sink.add({
        "username": username,
      });
      usernameChannel.stream.listen((event) {
        print("Event: " + event);
      });
      yield* usernameChannel.stream;
      usernameChannel.sink.close(status.goingAway);
    } catch (e, st) {
      if(e is WebSocketChannelException) {
        print("HIIII ${e.inner.toString()}");
        // emit(OnboardingError(e.message));
      }
      print("YOOOOOOOOOOOOOOO:" + e.toString());
      print(st);
      emit(OnboardingError(e.toString()));
    }
  }
}
