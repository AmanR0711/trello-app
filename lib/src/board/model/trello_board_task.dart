class TrelloBoardTask {
  final int id;
  final int listId;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  TrelloBoardTask(
    this.id,
    this.listId,
    this.title,
    this.description,
    this.completed,
    this.createdAt,
  );

  factory TrelloBoardTask.fromJson(Map<String, dynamic> json) {
    return TrelloBoardTask(
      json['id'],
      json['listId'],
      json['title'],
      json['description'],
      json['completed'],
      DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
