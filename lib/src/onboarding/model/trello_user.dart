import 'theme_type.dart';

class TrelloUser {
  final String username;
  final String email;
  final String avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ThemeType theme;

  TrelloUser({
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.theme,
    this.createdAt,
    this.updatedAt,
  });

  factory TrelloUser.fromJson(Map<String, dynamic> json) {
    return TrelloUser(
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      theme: ThemeType.values.firstWhere(
        (e) => e.themeName == json['theme'],
      ),
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
        'theme': theme.themeName,
      };

  @override
  String toString() {
    return 'TrelloUser(username: $username, email: $email, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, theme: $theme)';
  }
}
