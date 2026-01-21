// ignore_for_file: avoid_print

import 'package:api_amb_jwt/data/models/user.dart';
import 'package:api_amb_jwt/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserVM extends ChangeNotifier {
  late final IUserRepository _userRepository;

 UserVM({required IUserRepository userRepository})
    : _userRepository = userRepository;

  User? _currentUser;

  String get email => _currentUser?.email ?? '';
  String get password => _currentUser?.password ?? '';
  bool get authenticated => _currentUser?.authenticated ?? false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Intenta iniciar sessió amb l'email i contrasenya introduïts als controladors.
  Future<void> login() async {
    try {
      _currentUser = await _userRepository.validateLogin(
        emailController.text,
        passwordController.text,
      );
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Tanca la sessió actual i notifica als listeners.
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
