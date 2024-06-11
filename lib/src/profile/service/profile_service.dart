import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../onboarding/model/theme_type.dart';
import '../../onboarding/model/trello_user.dart';
import '../../onboarding/service/onboarding_service.dart';

class ProfileService {
  final Dio dio;
  final OnboardingService onboardingService;

  ProfileService(this.dio, this.onboardingService);

  Future<TrelloUser> getProfile() async {
    final user = await onboardingService.getSession();
    return user!;
  }

  Future<TrelloUser> updateProfile({
    String? username,
    ThemeType? theme,
    List<int>? avatar,
  }) async {
    final user = await getProfile();
    final res = await dio.patch(
      '/users/update/${user.email}',
      data: {
        'username': username ?? user.username,
        'theme': theme?.themeName ?? user.theme.themeName,
      },
    );
    if (avatar != null) {
      final data = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          avatar,
          filename: 'avatar.jpg',
          contentType: MediaType.parse('image/jpg'),
        ),
      });
      final resAvatar = await dio.post(
        '/users/avatar/upload',
        data: data,
        options: Options(
          contentType: 'multipart/form-data',
        ),
        queryParameters: {
          'email': user.email,
        },
      );
      print(resAvatar.data);
    }
    final updatedUser = TrelloUser.fromJson(res.data['data']);
    print("Old session: ${await onboardingService.getSession()}");
    await onboardingService.saveSession(updatedUser);
    print("New session: ${await onboardingService.getSession()}");
    return updatedUser;
  }
}
