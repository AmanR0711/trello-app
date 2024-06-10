import 'package:dio/dio.dart';

import '../../dashboard/model/trello_board_bg_color.dart';
import '../../onboarding/service/onboarding_service.dart';

class BoardService {
  final Dio dio;
  final OnboardingService onboardingService;

  BoardService(this.dio, this.onboardingService);

  Future<void> createBoard(
    String name,
    String description,
    TrelloBoardBgColor color,
  ) async {
    try {
      final user = await onboardingService.getSession();
      await dio.post(
        '/boards/create',
        data: {
          'name': name,
          'description': description,
          'bgColor': color.name,
          'username': user!.username,
        },
      );

    } on DioException catch (e) {
      throw Exception(e.response?.data['message']);
    }
  }
}
