import 'package:dio/dio.dart';

import '../../onboarding/service/onboarding_service.dart';
import '../model/trello_board.dart';

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
}
