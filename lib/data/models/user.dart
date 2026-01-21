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
    if (json.containsKey('access_token') && json.containsKey('user')) {
      final userJson = json['user'] as Map<String, dynamic>;
      return User(
        email: userJson['email'] ?? '',
        password: '', // La contrasenya no es retornada per Supabase
        authenticated: true,
        accessToken: json['access_token'],
      );
    }

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
