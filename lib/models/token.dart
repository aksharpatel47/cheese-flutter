import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  String token;
  String refreshToken;
  DateTime? expiryTime;

  Token(this.token, this.refreshToken);

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
  static const fromJsonFactory = _$TokenFromJson;
}
