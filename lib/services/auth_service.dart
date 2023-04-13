import 'package:async/async.dart';
import 'package:flutter_app/api_clients/cheese_client.dart';
import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/models/user.dart';
import 'package:injectable/injectable.dart';

abstract class IAuthService {
  bool get isLoggedIn;
  Future<Result<User>> login(LoginFormData loginFormData);
  void logOut();
}

@Singleton(as: IAuthService)
class AuthService implements IAuthService {
  CheeseClient _cheeseClient;

  AuthService(this._cheeseClient);

  bool _isLoggedIn = false;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  void logOut() {
    _isLoggedIn = false;
  }

  @override
  Future<Result<User>> login(LoginFormData loginFormData) async {
    final resp = await _cheeseClient.login(loginFormData);

    _isLoggedIn = resp.isValue;

    return resp;
  }
}
