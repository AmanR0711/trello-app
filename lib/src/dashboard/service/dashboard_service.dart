import 'package:dio/dio.dart';

import '../../onboarding/service/onboarding_service.dart';
import '../model/trello_board.dart';
import '../model/trello_board_bg_color.dart';

class DashboardService {
  final Dio dio;
  final OnboardingService onboardingService;

  DashboardService(this.dio, this.onboardingService);

  // Get all user boards
  Future<List<TrelloBoard>> getBoards() async {
    final user = await onboardingService.getSession();
    final res = await dio.get(
      '/boards',
      queryParameters: {"username": user!.username},
    );
    final List<TrelloBoard> boards = [];
    for (final board in res.data) {
      boards.add(TrelloBoard.fromJson(board));
    }
    return boards;
  }

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

  Future<void> deleteBoard(String boardId) async {
    try {
      await dio.delete('/boards/$boardId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message']);
    }
  }
}
