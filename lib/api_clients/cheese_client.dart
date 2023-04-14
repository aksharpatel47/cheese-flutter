import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/cheese_error.dart';
import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/repositories/auth_remote_repository.dart';
import 'package:flutter_app/repositories/token_remote_repository.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/json_value_convertor.dart';
import 'package:flutter_app/utils/preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'cheese_client_extension.dart';

@lazySingleton
class CheeseClient {
  late ChopperClient _client;

  ConfigManager _configManager;

  CheeseClient(this._configManager) {
    _client = _initClient();

    _configManager.remoteConfigDataStream.listen((event) {
      if (event.cheeseApiBaseUrl != _client.baseUrl.path) _client = _initClient();
    });
  }

  ChopperClient _initClient() {
    return ChopperClient(
      baseUrl: Uri.tryParse(_configManager.remoteConfigData?.cheeseApiBaseUrl ?? ""),
      authenticator: CheeseAuthenticator(),
    );
  }

  Future<Result<ChopperClient>> getClient({bool isAuthorized = true, Map<String, String>? headers}) async {
    Token? token;
    if (isAuthorized) {
      token = await GetIt.I<Preferences>().getCheeseToken();

      if (token == null) return Result.error(NoTokenFailure());
    }

    return Result.value(
      ChopperClient(
        baseUrl: _client.baseUrl,
        client: _client.httpClient,
        interceptors: [
          if (token != null) CheeseTokenHeader(token),
          if (headers?.isNotEmpty ?? false) HeadersInterceptor(headers!),
          CheeseRequestLogger(),
          CheeseResponseLogger(),
        ],
        services: [
          AuthRemoteRepository.create(),
          TokenRemoteRepository.create(),
        ],
        authenticator: _client.authenticator,
        converter: JsonValueConverter(),
        errorConverter: CheeseErrorConverter(),
      ),
    );
  }
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
        return response.copyWith(body: null, bodyError: DataFailure(ErrorMessages.dataFail));
    }

    var res = JsonTypeParser.decode<ResultType>(jsonDecode(response.body));

    if (res.isValue)
      return response.copyWith(body: res.asValue!.value);
    else {
      var error = res.asError!.error;

      return response.copyWith(body: null, bodyError: error is Failure ? error : DataFailure(ErrorMessages.dataFail));
    }
  }
}

class CheeseErrorConverter extends ErrorConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(Response response) {
    if (response.body != null) {
      var e = response.body is Map ? response.body : jsonDecode(response.body!.toString());
      var res = JsonTypeParser.decode<CheeseError>(e);

      if (res.isValue)
        return response.copyWith(body: null, bodyError: res.asValue!.value);
      else {
        var error = res.asError!.error;

        return response.copyWith(body: null, bodyError: error is Failure ? error : DataFailure(ErrorMessages.dataFail));
      }
    }
    return response.copyWith(body: null, bodyError: ServerFailure(ErrorMessages.serverFail, false));
  }
}

class CheeseAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(Request request, Response response, [Request? originalRequest]) async {
    if (response.statusCode == 401) {
      var pref = GetIt.I<Preferences>();
      var token = await pref.getCheeseToken();

      if (token != null) {
        var res = await GetIt.I<CheeseClient>().getClient();

        if (res.isError) return null;

        var client = res.asValue!.value;

        var tokenResp = await client.getService<TokenRemoteRepository>().refreshToken(token);

        if (tokenResp.body != null) {
          var token = tokenResp.body!;

          await pref.setCheeseToken(token);

          return request..headers.update("Authorization", (value) => token.token, ifAbsent: () => token.token);
        }
      }
      return null;
    } else
      return null;
  }
}

class CheeseTokenHeader extends HeadersInterceptor {
  CheeseTokenHeader(Token token) : super({"Authorization": token.token});
}

class CheeseRequestLogger extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    if (LogConstants.api)
      Logger().i(
          "[${request.method}] ${request.url}" +
              (request.body != null ? "\nbody : ${request.body}" : "") +
              (request.parameters.isNotEmpty ? "\nparams : ${request.parameters}" : "") +
              (LogConstants.header ? "\nheader : ${request.headers}" : ""),
          null,
          StackTrace.empty);

    return request;
  }
}

class CheeseResponseLogger extends ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response response) {
    if (LogConstants.responseData && response.body != null)
      Logger().d(jsonEncode(response.body), null, StackTrace.empty);
    if (LogConstants.responseData && response.error != null)
      Logger().e(
        "[${response.base.request?.method}] ${response.base.request?.url} \n ${jsonEncode(response.error)}",
        null,
        StackTrace.empty,
      );

    return response;
  }
}
