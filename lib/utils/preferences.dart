import 'dart:convert';

import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/remote_config_data.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/utils/json_value_convertor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _mysToken = 'mys_token';
  static const _cheeseToken = 'cheese_token';
  static const _weatherToken = 'weather_token';
  static const _appConfigKey = 'app_config';
  static const _user = 'cheese_user';

  final SharedPreferences _sharedPref;
  final FlutterSecureStorage _securedStorage;

  Preferences._(this._sharedPref, this._securedStorage);

  static Future<Preferences> getInstance() async {
    final sPref = await SharedPreferences.getInstance();

    final storage = FlutterSecureStorage();

    return Preferences._(sPref, storage);
  }

  Future<Token?> getMYSToken() async => await _getSecuredValue<Token>(_mysToken);
  Future<void> setMYSToken(Token token) async => await _setSecuredValue<Token>(_mysToken, token);
  Future<void> removeMYSToken() async => await _removeSecuredValue(_mysToken);

  Future<Token?> getCheeseToken() async => await _getSecuredValue<Token>(_cheeseToken);
  Future<void> setCheeseToken(Token token) async => await _setSecuredValue<Token>(_cheeseToken, token);
  Future<void> removeCheeseToken() async => await _removeSecuredValue(_cheeseToken);

  Future<Token?> getWeatherToken() async => await _getSecuredValue<Token>(_weatherToken);
  Future<void> setWeatherToken(Token token) async => await _setSecuredValue<Token>(_weatherToken, token);
  Future<void> removeWeatherToken() async => await _removeSecuredValue(_weatherToken);

  RemoteConfigData? getConfigs() => _getValue<RemoteConfigData>(_appConfigKey);
  Future<void> setConfigs(RemoteConfigData configs) async => await _setValue<RemoteConfigData>(_appConfigKey, configs);
  Future<void> removeConfigs() async => await _removeValue(_appConfigKey);

  Person? getUser() => _getValue<Person>(_user);
  Future<void> setUser(Person user) async => await _setValue<Person>(_user, user);
  Future<void> removeUser() async => await _removeValue(_user);

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
    var res = JsonTypeParser.decode<T>(jsonDecode(fetchedValue));

    if (res.isError) return null;
    return res.asValue!.value;
  }

  Future<void> _setValue<T>(dynamic key, T value) async => await _sharedPref.setString(key, jsonEncode(value));

  Future<void> _removeValue<T>(dynamic key) async => await _sharedPref.remove(key);

  Future<T?> _getSecuredValue<T>(dynamic key) async {
    final fetchedValue = await _securedStorage.read(key: key);
    if (fetchedValue == null) return null;
    var res = JsonTypeParser.decode<T>(jsonDecode(fetchedValue));

    if (res.isError) return null;
    return res.asValue!.value;
  }

  Future<void> _setSecuredValue<T>(dynamic key, T value) async =>
      await _securedStorage.write(key: key, value: jsonEncode(value));

  Future<void> _removeSecuredValue<T>(dynamic key) async => await _securedStorage.delete(key: key);
}
