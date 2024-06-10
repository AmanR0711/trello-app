// ignore_for_file: constant_identifier_names

enum TrelloListScopes {
  read_only("Read Only"),
  read_write("Read Write");

  final String scope;

  const TrelloListScopes(this.scope);
}

class TrelloListScope {
  final int listId;
  final TrelloListScopes scope;
  final String username;

  TrelloListScope({
    required this.listId,
    required this.scope,
    required this.username,
  });

  factory TrelloListScope.fromJson(Map<String, dynamic> json) {
    return TrelloListScope(
      listId: json['listId'],
      scope: TrelloListScopes.values.firstWhere(
        (e) => e.toString() == 'TrelloListScopes.${json['scope']}',
        orElse: () => TrelloListScopes.read_only,
      ),
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listId': listId,
      'scope': scope.scope,
      'username': username,
    };
  }
}
