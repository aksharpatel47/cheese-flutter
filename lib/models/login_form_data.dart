import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_data.g.dart';

@JsonSerializable()
class LoginFormData {
  final String username;
  final String password;

  LoginFormData(this.username, this.password);

  factory LoginFormData.fromJson(Map<String, dynamic> json) =>
      _$LoginFormDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginFormDataToJson(this);
}
