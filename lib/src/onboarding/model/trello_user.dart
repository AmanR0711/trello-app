class TrelloUser {
  final String username;
  final String email;
  final String avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TrelloUser({
    required this.username,
    required this.email,
    required this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory TrelloUser.fromJson(Map<String, dynamic> json) {
    return TrelloUser(
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      createdAt: DateTime.tryParse(json['createdAt']),
      updatedAt: DateTime.tryParse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'TrelloUser(username: $username, email: $email, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
