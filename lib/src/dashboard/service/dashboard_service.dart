import 'package:dio/dio.dart';

import '../../board/model/trello_board_list.dart';
import '../../board/model/trello_board_task.dart';
import '../../onboarding/service/onboarding_service.dart';
import '../model/trello_board.dart';
import '../model/trello_board_bg_color.dart';

class DashboardService {
  final Dio dio;
  final OnboardingService onboardingService;

  DashboardService(this.dio, this.onboardingService);

  // Get all user boards
  Future<List<TrelloBoard>> getBoards() async {
    try {
      final user = await onboardingService.getSession();
      if(user == null)
      {
        return [];
      }
      final res = await dio.get(
        '/boards',
        queryParameters: {"username": user!.username},
      );
      final List<TrelloBoard> boards = [];
      for (final board in res.data) {
        board['lists'] = [];
        board['tasks'] = [];
        boards.add(TrelloBoard.fromJson(board));
      }
      return boards;
    } catch (e, st) {
      print("getBoards: $e");
      print(st);
      return [];
    }
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

  Future<TrelloBoard?> getBoard(String boardId) async {
    try {
      final res = await dio.get('/boards/$boardId');
      if (res.data['message'] != null) {
        return null;
      }
      res.data['lists'] = [];
      res.data['tasks'] = [];
      final listRes = await dio.get('/lists/$boardId');
      List<TrelloBoardList> lists = [];
      List<TrelloBoardTask> tasks = [];
      for (final list in listRes.data) {
        list['tasks'] = [];
        list['scopes'] = [];
        lists.add(TrelloBoardList.fromJson(list));
        final task = await dio.get(
          '/tasks/$boardId?listId=${list['id']}',
        );
        task.data['listId'] = list['id'];
        tasks.add(TrelloBoardTask.fromJson(task.data));
      }
      final board = TrelloBoard.fromJson(res.data);
      board.lists.addAll(lists);
      for (final list in board.lists) {
        final listTasks =
            tasks.where((task) => task.listId == list.id).toList();
        print("listTasks: $listTasks");
        list.tasks.addAll(listTasks);
      }
      board.lists.addAll(lists);
      return board;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
