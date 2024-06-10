import 'trello_board_task.dart';
import 'trello_list_scope.dart';

class TrelloBoardList {
  final int id;
  final String name;
  final String description;
  final List<TrelloBoardTask> tasks;
  final List<TrelloListScope> listScopes;
  final DateTime createdAt;

  TrelloBoardList({
    required this.id,
    required this.name,
    required this.description,
    required this.tasks,
    required this.listScopes,
    required this.createdAt,
  });

  factory TrelloBoardList.fromJson(Map<String, dynamic> json) {
    return TrelloBoardList(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      tasks: List<Map<String, dynamic>>.from(json['tasks'])
          .map((e) => TrelloBoardTask.fromJson(e))
          .toList(),
      listScopes: List<Map<String, dynamic>>.from(json['scopes'])
          .map((e) => TrelloListScope.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'listScopes': listScopes.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
