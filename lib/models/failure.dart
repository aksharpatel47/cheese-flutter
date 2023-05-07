import 'package:flutter_app/models/standard_response.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'failure.g.dart';

@JsonSerializable()
class Failure {
  final String message;
  final bool isSupportType;

  Failure([this.message = "", this.isSupportType = false]);

  factory Failure.fromJson(Map<String, dynamic> json) => _$FailureFromJson(json);
  Map<String, dynamic> toJson() => _$FailureToJson(this);
}

@JsonSerializable()
class NetworkFailure extends Failure {
  NetworkFailure() : super(ErrorMessages.networkFail, false);

  factory NetworkFailure.fromJson(Map<String, dynamic> json) => _$NetworkFailureFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkFailureToJson(this);
}

@JsonSerializable()
class ServerFailure extends Failure {
  String? msg;
  List<ErrorMessage>? errors;

  ServerFailure(this.msg, this.errors)
      : super(msg ?? errors?.map<String?>((e) => e.message).whereType<String>().join(", ") ?? ErrorMessages.serverFail,
            errors?.isNotEmpty ?? false);

  factory ServerFailure.fromJson(Map<String, dynamic> json) => _$ServerFailureFromJson(json);
  Map<String, dynamic> toJson() => _$ServerFailureToJson(this);
}

@JsonSerializable()
class InternalFailure extends Failure {
  String? msg;
  InternalFailure(this.msg) : super(msg ?? ErrorMessages.internalFail, true);

  factory InternalFailure.fromJson(Map<String, dynamic> json) => _$InternalFailureFromJson(json);
  Map<String, dynamic> toJson() => _$InternalFailureToJson(this);
}

@JsonSerializable()
class DataFailure extends Failure {
  String? msg;
  DataFailure([this.msg]) : super(msg ?? ErrorMessages.dataFail, true);

  factory DataFailure.fromJson(Map<String, dynamic> json) => _$DataFailureFromJson(json);
  Map<String, dynamic> toJson() => _$DataFailureToJson(this);
}

@JsonSerializable()
class TokenExpiryFailure extends Failure {
  TokenExpiryFailure() : super(ErrorMessages.tokenExpiry, false);

  factory TokenExpiryFailure.fromJson(Map<String, dynamic> json) => _$TokenExpiryFailureFromJson(json);
  Map<String, dynamic> toJson() => _$TokenExpiryFailureToJson(this);
}

@JsonSerializable()
class NoTokenFailure extends Failure {
  NoTokenFailure() : super(ErrorMessages.noToken, false);

  factory NoTokenFailure.fromJson(Map<String, dynamic> json) => _$NoTokenFailureFromJson(json);
  Map<String, dynamic> toJson() => _$NoTokenFailureToJson(this);
}

@JsonSerializable()
class TimeoutFailure extends Failure {
  String? msg;
  TimeoutFailure([this.msg]) : super(msg ?? ErrorMessages.timeOut, true);

  factory TimeoutFailure.fromJson(Map<String, dynamic> json) => _$TimeoutFailureFromJson(json);
  Map<String, dynamic> toJson() => _$TimeoutFailureToJson(this);
}
