import '../../onboarding/model/trello_user.dart';
import 'trello_board_bg_color.dart';
import 'trello_board_user_scope.dart';

class TrelloBoard {
  final String id;
  final String name;
  final String description;
  final TrelloBoardBgColor bgColor;
  final TrelloUser creator;
  final List<TrelloBoardUserScope> scopes;
  final DateTime createdAt;

  TrelloBoard({
    required this.id,
    required this.name,
    required this.description,
    required this.bgColor,
    required this.creator,
    required this.scopes,
    required this.createdAt,
  });

  factory TrelloBoard.fromJson(Map<String, dynamic> json) {
    return TrelloBoard(
      id: json['id'],
      name: json['name'],
      bgColor: TrelloBoardBgColor.values.firstWhere(
        (element) =>
            element.toString() == 'TrelloBoardBgColor.${json['bgColor']}',
        orElse: () => TrelloBoardBgColor.white,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      creator: TrelloUser.fromJson(json['creator']),
      scopes: List<Map<String, dynamic>>.from(json['scopes'])
          .map((e) => TrelloBoardUserScope.fromJson(e))
          .toList(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'bgColor': bgColor.toString().split('.').last,
      'creator': creator.toJson(),
      'scopes': scopes.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
