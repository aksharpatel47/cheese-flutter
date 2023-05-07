import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  String token;
  String refreshToken;
  DateTime? expiryTime;

  bool get isExpired => expiryTime?.isBefore(DateTime.now()) ?? true;

  Token(this.token, this.refreshToken) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final exp = decodedToken["exp"];
    final iat = decodedToken["iat"];
    expiryTime = DateTime.now().add(Duration(seconds: exp - iat));
  }

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
  static const fromJsonFactory = _$TokenFromJson;
}
