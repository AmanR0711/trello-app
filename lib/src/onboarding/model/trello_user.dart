class TrelloUser {
  final String username;
  final String email;
  final String avatarUrl;

  TrelloUser({
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  factory TrelloUser.fromJson(Map<String, dynamic> json) {
    return TrelloUser(
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
      };

  @override
  String toString() {
    return 'TrelloUser(username: $username, email: $email, avatarUrl: $avatarUrl)';
  }
}
