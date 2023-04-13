import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/weather.dart';
import 'package:flutter_app/repositories/weather_remote_repository.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'weather_client_extension.dart';

@lazySingleton
class WeatherClient {
  late ChopperClient _client;

  ConfigManager _configManager;

  WeatherClient(this._configManager) {
    _client = _initClient();

    _configManager.remoteConfigDataStream.listen((event) {
      if (event.weatherApiBaseUrl != _client.baseUrl.path) _client = _initClient();
    });
  }

  ChopperClient _initClient() {
    return ChopperClient(
      baseUrl: Uri.tryParse(_configManager.remoteConfigData?.weatherApiBaseUrl ?? ""),
      interceptors: [
        WeatherRequestLogger(),
        WeatherAccessKeyInjector(),
        WeatherResponseLogger(),
      ],
      services: [
        WeatherRemoteRepository.create(),
      ],
    );
  }

  ChopperClient get client => _client;
}

class WeatherAccessKeyInjector extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    var configs = GetIt.I<ConfigManager>().remoteConfigData;

    if (configs != null) request.parameters.putIfAbsent('access_key', () => configs.weatherApiAccessKey);

    return request;
  }
}

class WeatherRequestLogger extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    if (LogConstants.api)
      Logger().i(
          "[${request.method}] ${request.url.path}" +
              (request.body != null ? "\nbody : ${jsonEncode(request.body)}" : "") +
              (request.parameters.isNotEmpty ? "\nparams : ${request.parameters}" : "") +
              (LogConstants.header ? "\nheader : ${request.headers}" : ""),
          null,
          StackTrace.empty);

    return request;
  }
}

class WeatherResponseLogger extends ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response response) {
    if (LogConstants.responseData) Logger().d(response.body);

    return response;
  }
}
