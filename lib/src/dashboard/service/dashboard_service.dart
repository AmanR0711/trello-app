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
      if (user == null) {
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
      // Get board details
      final res = await dio.get('/boards/$boardId');
      // If error, return null
      if (res.data['message'] != null) {
        return null;
      }
      // Each board needs a list of tasks and lists
      res.data['lists'] = [];
      res.data['tasks'] = [];
      List<TrelloBoardList> listsObj = [];
      List<TrelloBoardTask> tasksObj = [];

      // Retrieve lists for a boardId
      final listRes = await dio.get('/lists/$boardId');
      // Retrieve tasks for a give list
      for (final list in listRes.data) {
        list['tasks'] = [];
        list['listScopes'] = [];
        listsObj.add(TrelloBoardList.fromJson(list));
        final tasks = await dio.get(
          '/tasks/$boardId/all?listId=${list['id']}',
        );
        for (final task in tasks.data) {
          task['listId'] = list['id'];
          list['tasks'].add(task);
        }
        tasksObj.addAll(List<Map<String, dynamic>>.from(tasks.data)
            .map(
              (task) => TrelloBoardTask.fromJson(task),
            )
            .toList());
      }
      final board = TrelloBoard.fromJson(res.data);
      board.lists.addAll(listsObj);
      return board;
    } catch (e, st) {
      print("getBoard: $e");
      print(st);
      throw Exception(e.toString());
    }
  }

  Future<void> createList(
    String boardId,
    String name,
    String description,
  ) async {
    try {
      final user = await onboardingService.getSession();
      if (user != null) {
        await dio.post(
          '/lists/$boardId/create',
          data: {
            'name': name,
            'description': description,
            'boardId': boardId,
            'username': user.username,
          },
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message']);
    }
  }
}
