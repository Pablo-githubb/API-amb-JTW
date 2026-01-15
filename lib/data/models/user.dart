class User {
  final String email;
  final String password;
  final bool authenticated;
  final String accessToken;
  User({
    required this.email,
    required this.password,
    required this.authenticated,
    required this.accessToken,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email,
        'password': String password,
        'accessToken': String accessToken,
      } =>
        User(
          email: email,
          password: password,
          authenticated: true,
          accessToken: accessToken,
        ),
      _ => throw const FormatException('Failed to load User.'),
    };
  }
}
