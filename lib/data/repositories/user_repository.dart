import 'package:api_amb_jwt/data/models/user.dart';
import 'package:api_amb_jwt/data/services/user_service.dart';

abstract class IUserRepository {
  User get email;
  bool get authenticated;
  Future<User> validateLogin(String email, String password);
}

class UserRepository implements IUserRepository {
  UserRepository({required IUserService userService})
    : _userService = userService;

  final IUserService _userService;
  User? _user;

  //Retorna true si hi ha un usuari i la seva propietat authenticated és certa
  @override
  /// Comprova si l'usuari actual ha iniciat sessió correctament.
  bool get authenticated {
    return _user == null || !_user!.authenticated ? false : true;
  }

  @override
  /// Retorna l'objecte User complet si està autenticat, sinó llança excepció.
  User get email {
    if (_user == null) {
      throw Exception('User not authenticated');
    }
    return _user!;
  }

  @override
  /// Valida les credencials del login mitjançant el servei i emmagatzema l'usuari resultant.
  Future<User> validateLogin(String email, String password) async {
    _user = await _userService.validateLogin(email, password);
    return _user!;
  }
}