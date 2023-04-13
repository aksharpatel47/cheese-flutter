import 'package:flutter_app/utils/constants.dart';

class Failure {
  final String message;
  final bool isSupportType;

  Failure([this.message = "", this.isSupportType = false]);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super(ErrorMessages.networkFail, false);
}

class ServerFailure extends Failure {
  ServerFailure(String? msg, bool isSupportType) : super(msg ?? ErrorMessages.serverFail, isSupportType);
}

class InternalFailure extends Failure {
  InternalFailure(String? msg) : super(msg ?? ErrorMessages.internalFail, true);
}

class DataFailure extends Failure {
  DataFailure(String? msg) : super(msg ?? ErrorMessages.dataFail, true);
}

class TokenExpiryFailure extends Failure {
  TokenExpiryFailure() : super(ErrorMessages.tokenExpiry, false);
}

class NoTokenFailure extends Failure {
  NoTokenFailure() : super(ErrorMessages.noToken, false);
}

class TimeoutFailure extends Failure {
  TimeoutFailure([String? msg]) : super(msg ?? ErrorMessages.timeOut, true);
}
