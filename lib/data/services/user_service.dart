import 'package:api_amb_jwt/data/models/user.dart';

abstract class IUserService{
  Future<User> validateLogin(String email, String password);
}

class UserService implements IUserService {
  @override
  Future<User> validateLogin(String email, String password) {
    // TODO: implement validateLogin
    throw UnimplementedError();
  }

}
