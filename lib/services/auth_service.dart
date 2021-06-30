import 'package:flutter_app/models/login_form_data.dart';
import 'package:injectable/injectable.dart';

abstract class IAuthService {
  bool get isLoggedIn;
  void login(LoginFormData loginFormData);
  void logOut();
}

@Singleton(as: IAuthService)
class AuthService implements IAuthService {
  bool _isLoggedIn = false;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  void logOut() {
    _isLoggedIn = false;
  }

  @override
  void login(LoginFormData loginFormData) {
    _isLoggedIn = true;
  }
}
