import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/position.dart';
import 'package:flutter_app/models/standard_response.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/repositories/people_remote_repository.dart';
import 'package:flutter_app/repositories/token_remote_repository.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/json_value_convertor.dart';
import 'package:flutter_app/utils/preferences.dart';
import 'package:flutter_app/utils/string_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'myseva_client_extension.dart';

@lazySingleton
class MYSClient {
  late ChopperClient _client;

  ConfigManager _configManager;

  MYSClient(this._configManager) {
    _client = _initClient();

    _configManager.remoteConfigDataStream.listen((event) {
      if (event.mysApiBaseUrl != _client.baseUrl.path) _client = _initClient();
    });
  }

  ChopperClient _initClient() {
    return ChopperClient(
      baseUrl: Uri.tryParse(_configManager.remoteConfigData?.mysApiBaseUrl ?? ""),
      authenticator: MYSAuthenticator(),
    );
  }

  Future<Result<ChopperClient>> getClient(
      {bool isAuthorized = true, bool allowExpired = false, Map<String, String>? headers}) async {
    Token? token;
    if (isAuthorized) {
      token = await GetIt.I<Preferences>().getMYSToken();

      if (token == null) return Result.error(NoTokenFailure());

      if (!allowExpired && token.isExpired) {
        var newTokenResp = await refreshToken(token);

        if (newTokenResp.isValue)
          token = newTokenResp.asValue!.value;
        else
          return Result.error(NoTokenFailure());
      }
    }

    return Result.value(
      ChopperClient(
        baseUrl: _client.baseUrl,
        client: _client.httpClient,
        interceptors: [
          if (token != null) MYSTokenHeader(token),
          if (headers?.isNotEmpty ?? false) HeadersInterceptor(headers!),
          MYSRequestLogger(),
          MYSResponseLogger(),
        ],
        services: [
          TokenRemoteRepository.create(),
          PeopleRemoteRepository.create(),
        ],
        authenticator: _client.authenticator,
        converter: JsonValueConverter(),
        errorConverter: MYSErrorConverter(),
      ),
    );
  }
}

class MYSErrorConverter extends ErrorConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(Response response) {
    try {
      if (response.body != null) {
        var e = response.body is Map ? response.body : jsonDecode(response.body!.toString());
        var res = JsonTypeParser.decode<StandardResponse>(e);

        if (res.isValue)
          return response.copyWith(body: null, bodyError: res.asValue!.value);
        else {
          var error = res.asError!.error;

          return response.copyWith(
              body: null, bodyError: error is Failure ? error : DataFailure(ErrorMessages.dataFail));
        }
      }
      return response.copyWith(body: null, bodyError: ServerFailure(ErrorMessages.serverFail, null));
    } catch (e) {
      Logger().e(e);
      return response.copyWith(body: null, bodyError: ServerFailure(ErrorMessages.serverFail, null));
    }
  }
}

class MYSTokenHeader extends HeadersInterceptor {
  MYSTokenHeader(Token token) : super({"Authorization": token.token});
}

class MYSAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(Request request, Response response, [Request? originalRequest]) async {
    if (response.statusCode == 401) {
      var pref = GetIt.I<Preferences>();
      var token = await pref.getMYSToken();

      if (token != null) {
        var res = await GetIt.I<MYSClient>().getClient();

        if (res.isError) return null;

        var client = res.asValue!.value;

        var tokenResp = await client.getService<TokenRemoteRepository>().refreshToken(token);

        if (tokenResp.body != null) {
          var token = tokenResp.body!;

          await pref.setMYSToken(token);

          return request..headers.update("Authorization", (value) => token.token, ifAbsent: () => token.token);
        }
      }
      return null;
    } else
      return null;
  }
}

class MYSRequestLogger extends RequestInterceptor {
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

class MYSResponseLogger extends ResponseInterceptor {
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

    var res = JsonTypeParser.decode<StandardResponse>(jsonDecode(response.body));

    if (res.isValue) {
      var stdResp = res.asValue!.value;

      StandardResponse<ResultType, Item> convertedStdResp = StandardResponse<ResultType, Item>(
        stdResp.succeeded,
        stdResp.message,
        stdResp.errors,
        stdResp.dataDoNotUse,
      );

      if (convertedStdResp.succeeded && convertedStdResp.data != null) {
        return response.copyWith(body: convertedStdResp.data, bodyError: null);
      } else {
        if (!convertedStdResp.succeeded && convertedStdResp.message.hasValue) {
          return Response<ResultType>(
            response.base,
            null,
            error: ServerFailure(convertedStdResp.message, null),
          );
        } else if (!convertedStdResp.succeeded &&
            !convertedStdResp.message.hasValue &&
            (convertedStdResp.errors?.isNotEmpty ?? false)) {
          return Response<ResultType>(
            response.base,
            null,
            error: ServerFailure(null, convertedStdResp.errors),
          );
        }
        return Response<ResultType>(
          response.base,
          null,
          error: DataFailure(),
        );
      }
    } else {
      var error = res.asError!.error;

      return Response<ResultType>(
        response.base,
        null,
        error: error is Failure ? error : DataFailure(ErrorMessages.dataFail),
      );
    }
  }
}
