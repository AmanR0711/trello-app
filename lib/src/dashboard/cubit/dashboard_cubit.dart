import 'package:flutter_bloc/flutter_bloc.dart';

import '../../onboarding/service/onboarding_service.dart';
import '../model/trello_board.dart';
import '../model/trello_board_bg_color.dart';
import '../service/dashboard_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardService dashboardService;
  final OnboardingService onboardingService;

  DashboardCubit(
    this.dashboardService,
    this.onboardingService,
  ) : super(DashboardLoading());

  Future<void> getBoards() async {
    try {
      emit(DashboardLoading());
      final user = await onboardingService.getSession();
      final boards = await dashboardService.getBoards();
      emit(DashboardLoaded(user!, boards));
    } catch (e) {
      print("dashboard cubit $e");
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> createBoard(
    String name,
    String description,
    TrelloBoardBgColor color,
  ) async {
    try {
      emit(DashboardLoading());
      await dashboardService.createBoard(name, description, color);
      getBoards();
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> deleteBoard(String boardId) async {
    try {
      emit(DashboardLoading());
      await dashboardService.deleteBoard(boardId);
      getBoards();
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<TrelloBoard?> getBoard(String boardId) async {
    try {
      final board = await dashboardService.getBoard(boardId);
      return board;
    } catch (e) {
      return null;
    }
  }

  Future<void> createList({
    required String boardId,
    required String name,
    required String description,
  }) async {
    try {
      emit(DashboardLoading());
      await dashboardService.createList(boardId, name, description);
      getBoards();
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
