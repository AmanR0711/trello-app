import 'trello_board_scope.dart';

class TrelloBoardUserScope {
  final String username;
  final TrelloBoardScope boardScope;

  TrelloBoardUserScope(this.username, this.boardScope);

  factory TrelloBoardUserScope.fromJson(Map<String, dynamic> json) {
    return TrelloBoardUserScope(
      json['username'],
      TrelloBoardScope.values.firstWhere((element) => element.scope == json['scope']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'scope': boardScope.scope,
    };
  }
}