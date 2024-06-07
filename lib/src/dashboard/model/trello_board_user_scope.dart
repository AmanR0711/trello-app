import '../../onboarding/model/trello_user.dart';
import 'trello_board_scope.dart';

class TrelloBoardUserScope {
  final TrelloUser user;
  final TrelloBoardScope boardScope;

  TrelloBoardUserScope(this.user, this.boardScope);

  factory TrelloBoardUserScope.fromJson(Map<String, dynamic> json) {
    return TrelloBoardUserScope(
      TrelloUser.fromJson(json['user']),
      TrelloBoardScope.values.firstWhere((element) => element.scope == json['scope']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'scope': boardScope.scope,
    };
  }
}