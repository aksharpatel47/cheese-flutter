import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

part 'remote_config_data.g.dart';

@JsonSerializable()
class RemoteConfigData {
  final String storeUrl;
  @VersionConverter()
  final Version minimumVersion;
  @VersionConverter()
  final Version latestVersion;
  final String privacyUrl;
  final String termsUrl;
  final String cheeseApiBaseUrl;
  final String weatherApiBaseUrl;
  final String weatherApiAccessKey;

  RemoteConfigData({
    required this.minimumVersion,
    required this.latestVersion,
    required this.storeUrl,
    required this.privacyUrl,
    required this.termsUrl,
    required this.cheeseApiBaseUrl,
    required this.weatherApiBaseUrl,
    required this.weatherApiAccessKey,
  });

  factory RemoteConfigData.fromRemoteConfig(Map<String, RemoteConfigValue> config) {
    var appVersion = Version.parse(GetIt.I<PackageInfo>().version);

    Version minimumVersion = convertVersion(config[ConfigKeys.minimumVersion]?.asString()) ?? appVersion;

    Version latestVersion = convertVersion(config[ConfigKeys.latestVersion]?.asString()) ?? appVersion;

    String storeUrl = config[ConfigKeys.storeUrl]?.asString() ?? "";

    String privacyUrl = config[ConfigKeys.privacyUrl]?.asString() ?? "";

    String termsUrl = config[ConfigKeys.termsUrl]?.asString() ?? "";

    String cheeseApiBaseUrl = config[ConfigKeys.cheeseApiBaseUrl]?.asString() ?? "";

    String weatherApiBaseUrl = config[ConfigKeys.weatherApiBaseUrl]?.asString() ?? "";

    String weatherApiAccessKey = config[ConfigKeys.weatherApiAccessKey]?.asString() ?? "";

    return RemoteConfigData(
      minimumVersion: minimumVersion,
      latestVersion: latestVersion,
      storeUrl: storeUrl,
      privacyUrl: privacyUrl,
      termsUrl: termsUrl,
      cheeseApiBaseUrl: cheeseApiBaseUrl,
      weatherApiBaseUrl: weatherApiBaseUrl,
      weatherApiAccessKey: weatherApiAccessKey,
    );
  }

  factory RemoteConfigData.empty() => RemoteConfigData(
        minimumVersion: Version.parse(GetIt.I<PackageInfo>().version),
        latestVersion: Version.parse(GetIt.I<PackageInfo>().version),
        storeUrl: "",
        privacyUrl: "",
        termsUrl: "",
        cheeseApiBaseUrl: "",
        weatherApiBaseUrl: "",
        weatherApiAccessKey: "",
      );

  factory RemoteConfigData.fromJson(Map<String, dynamic> json) => _$RemoteConfigDataFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteConfigDataToJson(this);
}

Version? convertVersion(String? version) {
  try {
    return Version.parse(version ?? "");
  } on FormatException catch (e) {
    debugPrint(e.message);
    return null;
  }
}

class VersionConverter extends JsonConverter<Version, String> {
  const VersionConverter();

  @override
  Version fromJson(String json) => Version.parse(json);

  @override
  String toJson(Version object) => object.toString();
}

class ConfigKeys {
  static final storeUrl = "store_url";
  static final minimumVersion = "minimum_version";
  static final latestVersion = "latest_version";
  static final privacyUrl = "privacy_url";
  static final termsUrl = "terms_url";
  static final cheeseApiBaseUrl = "cheese_api_base_url";
  static final weatherApiBaseUrl = "weather_api_base_url";
  static final weatherApiAccessKey = "weather_api_access_key";
}
