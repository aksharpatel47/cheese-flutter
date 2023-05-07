import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_app/models/remote_config_data.dart';
import 'package:flutter_app/utils/preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class ConfigManager {
  final FirebaseRemoteConfig _remoteConfig;
  final Preferences _pref;
  RemoteConfigData? _remoteConfigData;

  RemoteConfigData? get remoteConfigData => _remoteConfigData;

  StreamController<RemoteConfigData> _remoteConfigController = StreamController<RemoteConfigData>.broadcast();
  Stream<RemoteConfigData> get remoteConfigDataStream => _remoteConfigController.stream;

  ConfigManager(this._remoteConfig, this._pref);

  Future<bool> init() async {
    bool fetched = true;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 1),
    ));

    try {
      await _remoteConfig.fetchAndActivate();

      final config = _remoteConfig.getAll();

      _remoteConfigData = RemoteConfigData.fromRemoteConfig(config);

      await _pref.setConfigs(_remoteConfigData!);
    } catch (e) {
      Logger().e(e);
      var storedConfig = _pref.getConfigs();

      if (storedConfig == null) fetched = false;

      _remoteConfigData = storedConfig;
    }

    _remoteConfigController.sink.add(_remoteConfigData!);

    return fetched;
  }

  dispose() {
    _remoteConfigController.close();
  }
}
