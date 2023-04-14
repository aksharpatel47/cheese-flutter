import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/weather.dart';
import 'package:flutter_app/repositories/weather_remote_repository.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/json_value_convertor.dart';
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
        WeatherAccessKeyInjector(),
        WeatherRequestLogger(),
        WeatherResponseLogger(),
      ],
      services: [
        WeatherRemoteRepository.create(),
      ],
      converter: JsonValueConverter(),
    );
  }

  ChopperClient get client => _client;
}

class JsonValueConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    return super.convertRequest(request);
  }

  @override
  Future<Response<ResultType>> convertResponse<ResultType, Item>(Response response) async {
    var body = jsonDecode(response.body);

    if (body is Iterable) {
      var res = JsonTypeParser.decodeList<Item>(jsonDecode(response.body)).map((e) => e.asValue!.value).toList();

      if (res is ResultType)
        return response.copyWith(body: res as ResultType);
      else
        return Response(response.base, null, error: DataFailure(ErrorMessages.dataFail));
    }

    var res = JsonTypeParser.decode<ResultType>(jsonDecode(response.body));

    if (res.isValue)
      return response.copyWith(body: res.asValue!.value);
    else {
      var error = res.asError!.error;

      return Response(response.base, null, error: error is Failure ? error : DataFailure(ErrorMessages.dataFail));
    }
  }
}

class WeatherAccessKeyInjector extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    var configs = GetIt.I<ConfigManager>().remoteConfigData;

    if (configs != null)
      request.parameters
          .update('access_key', (value) => configs.weatherApiAccessKey, ifAbsent: () => configs.weatherApiAccessKey);

    return request.copyWith();
  }
}

class WeatherRequestLogger extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    if (LogConstants.api)
      Logger().i(
          "[${request.method}] ${request.url}" +
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
    if (LogConstants.responseData)
      Logger().d(
        jsonEncode(response.body),
        null,
        StackTrace.empty,
      );

    return response;
  }
}
