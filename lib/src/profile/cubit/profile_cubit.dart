import 'package:flutter_bloc/flutter_bloc.dart';

import '../../onboarding/model/theme_type.dart';
import '../service/profile_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService profileService;

  ProfileCubit(this.profileService) : super(ProfileLoading());

  void getProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await profileService.getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void updateProfile({
    String? username,
    ThemeType? theme,
    List<int>? avatar,
  }) async {
    try {
      emit(ProfileLoading());
      final profile = await profileService.updateProfile(
        username: username,
        theme: theme,
        avatar: avatar,
      );
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
