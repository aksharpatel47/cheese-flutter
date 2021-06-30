import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Connectivity get connection => Connectivity();

  RemoteConfig get remoteConfig => RemoteConfig.instance;

// DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

// @preResolve
// Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
