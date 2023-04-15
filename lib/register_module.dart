import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_app/utils/preferences.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<Preferences> get pref => Preferences.getInstance();

  Connectivity get connection => Connectivity();

  FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;

// DeviceInfoPlugin get deviceInfo => DeviceInfoPlugin();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
