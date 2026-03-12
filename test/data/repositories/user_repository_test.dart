import 'package:api_amb_jwt/data/models/user.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
import 'package:api_amb_jwt/data/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';

class MockUserService implements IUserService {
  User? userToReturn;
  Exception? exceptionToThrow;
  String? lastEmail;
  String? lastPassword;

  @override
  Future<User> validateLogin(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return userToReturn!;
  }
}

User _makeUser({bool authenticated = true, String email = 'test@test.com', String token = 'token'}) {
  return User(email: email, password: '', authenticated: authenticated, accessToken: token);
}

void main() {
  late MockUserService mockService;
  late UserRepository repo;

  setUp(() {
    mockService = MockUserService();
    repo = UserRepository(userService: mockService);
  });

  group('UserRepository', () {
    test('authenticated: false initially, true/false after login depending on flag', () async {
      expect(repo.authenticated, isFalse);

      mockService.userToReturn = _makeUser(authenticated: true);
      await repo.validateLogin('test@test.com', 'pass');
      expect(repo.authenticated, isTrue);

      // Login with non-authenticated user
      mockService.userToReturn = _makeUser(authenticated: false);
      await repo.validateLogin('test@test.com', 'pass');
      expect(repo.authenticated, isFalse);
    });

    test('email: throws when no user, returns User after login', () async {
      expect(() => repo.email, throwsA(isA<Exception>()));

      mockService.userToReturn = _makeUser(email: 'john@example.com', token: 'my-token');
      await repo.validateLogin('john@example.com', 'pass');

      final result = repo.email;
      expect(result.email, 'john@example.com');
      expect(result.accessToken, 'my-token');
    });

    test('validateLogin delegates to service and returns User', () async {
      mockService.userToReturn = _makeUser(email: 'a@b.com', token: 'tok');

      final result = await repo.validateLogin('a@b.com', 'mypassword');

      expect(mockService.lastEmail, 'a@b.com');
      expect(mockService.lastPassword, 'mypassword');
      expect(result.email, 'a@b.com');
      expect(result.accessToken, 'tok');
    });

    test('validateLogin throws when service throws', () {
      mockService.exceptionToThrow = Exception('Invalid credentials');

      expect(() => repo.validateLogin('a@b.com', 'wrong'), throwsA(isA<Exception>()));
    });
  });
}
