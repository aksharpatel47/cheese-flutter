import 'package:async/async.dart';
import 'package:flutter_app/api_clients/cheese_client.dart';
import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/utils/preferences.dart';
import 'package:injectable/injectable.dart';

abstract class IAuthService {
  bool get isLoggedIn;
  User? get user;
  Future<Result<User>> login(LoginFormData loginFormData);
  Future<void> logOut();
  Future<void> checkLogin();
}

@Singleton(as: IAuthService)
class AuthService implements IAuthService {
  CheeseClient _cheeseClient;
  Preferences _pref;

  AuthService(this._cheeseClient, this._pref);

  User? _user;

  @override
  bool get isLoggedIn => _user != null;

  @override
  User? get user => _user;

  @override
  Future<void> logOut() async {
    await _pref.removeCheeseToken();
    await _pref.removeUser();

    _user = null;
  }

  @override
  Future<Result<User>> login(LoginFormData loginFormData) async {
    final resp = await _cheeseClient.login(loginFormData);

    if (resp.isValue) {
      _user = resp.asValue!.value;

      await _pref.setCheeseToken(Token(_user!.token, ""));
      await _pref.setUser(_user!);
    }

    return resp;
  }

  @override
  Future<void> checkLogin() async {
    var token = await _pref.getCheeseToken();
    if (token != null) {
      var user = _pref.getUser();
      if (user != null) {
        _user = user;
      }
    }
  }
}
