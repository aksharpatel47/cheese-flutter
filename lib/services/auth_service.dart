import 'package:async/async.dart';
import 'package:flutter_app/api_clients/myseva_client.dart';
import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/utils/preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

abstract class IAuthService {
  bool get isLoggedIn;
  Person? get user;
  Future<Result<Person>> login(Token token);
  Future<void> logOut();
  Future<Result<void>> checkLogin();
}

@Singleton(as: IAuthService)
class AuthService implements IAuthService {
  MYSClient _mysClient;
  Preferences _pref;

  AuthService(this._mysClient, this._pref);

  Person? _user;

  @override
  bool get isLoggedIn => _user != null;

  @override
  Person? get user => _user;

  @override
  Future<void> logOut() async {
    await _pref.removeMYSToken();
    await _pref.removeUser();

    _user = null;
  }

  @override
  Future<Result<Person>> login(Token token) async {
    var decodedToken = JwtDecoder.decode(token.token);

    await _pref.setMYSToken(token);

    final personId = int.tryParse(decodedToken['pid'].toString());

    if (personId is int) {
      final resp = await _mysClient.getPeople([personId]);

      if (resp.isValue && resp.asValue!.value.isNotEmpty) {
        _user = resp.asValue!.value.first;

        await _pref.setUser(_user!);

        return Result.value(_user!);
      } else if (resp.isValue) {
        return Result.error(DataFailure());
      } else {
        return Result.error(resp.asError!.error);
      }
    } else {
      return Result.error(InternalFailure("pid not found in token"));
    }
  }

  @override
  Future<Result<void>> checkLogin() async {
    var token = await _pref.getMYSToken();
    if (token != null) {
      Logger().i("Stored Token\n${token.token}", null, StackTrace.empty);

      var user = _pref.getUser();
      if (user != null) {
        _user = user;
        return Result.value(null);
      } else {
        var loginResp = await login(token);

        if (loginResp.isValue) return Result.value(null);

        await logOut();

        return Result.error(loginResp.asError!.error);
      }
    }

    return Result.error(NoTokenFailure());
  }
}
