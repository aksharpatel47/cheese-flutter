import 'dart:convert';

import 'package:flutter_app/models/remote_config_data.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/utils/json_value_convertor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _userToken = 'sso_token';
  static const _appConfigKey = 'app_config';

  final SharedPreferences _sharedPref;
  final FlutterSecureStorage _securedStorage;

  Preferences._(this._sharedPref, this._securedStorage);

  static Future<Preferences> getInstance() async {
    final sPref = await SharedPreferences.getInstance();

    final storage = FlutterSecureStorage();

    return Preferences._(sPref, storage);
  }

  Future<Token?> getToken() async => await _getSecuredValue<Token>(_userToken);
  Future<void> setToken(Token token) async => await _setSecuredValue<Token>(_userToken, token);
  Future<void> removeToken() async => await _removeSecuredValue(_userToken);

  RemoteConfigData? getConfigs() => _getValue<RemoteConfigData>(_appConfigKey);
  Future<void> setConfigs(RemoteConfigData configs) async => await _setValue<RemoteConfigData>(_appConfigKey, configs);
  Future<void> removeConfigs() async => await _removeValue(_appConfigKey);

  ///clear all stored preference value
  ///
  ///avoid using this
  Future<void> clearPreference() async {
    await _securedStorage.deleteAll();
    await _sharedPref.clear();
  }

  T? _getValue<T>(dynamic key) {
    final fetchedValue = _sharedPref.getString(key);
    if (fetchedValue == null) return null;
    try {
      return JsonTypeParser.decode<T>(jsonDecode(fetchedValue));
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<void> _setValue<T>(dynamic key, T value) async => await _sharedPref.setString(key, jsonEncode(value));

  Future<void> _removeValue<T>(dynamic key) async => await _sharedPref.remove(key);

  Future<T?> _getSecuredValue<T>(dynamic key) async {
    final fetchedValue = await _securedStorage.read(key: key);
    if (fetchedValue == null) return null;
    try {
      return JsonTypeParser.decode<T>(jsonDecode(fetchedValue));
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<void> _setSecuredValue<T>(dynamic key, T value) async =>
      await _securedStorage.write(key: key, value: jsonEncode(value));

  Future<void> _removeSecuredValue<T>(dynamic key) async => await _securedStorage.delete(key: key);
}
