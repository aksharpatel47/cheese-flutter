import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(defaultValue: 0)
  int id;
  @JsonKey(defaultValue: '')
  String username;
  @JsonKey(defaultValue: '')
  String email;
  @JsonKey(defaultValue: '')
  String firstName;
  @JsonKey(defaultValue: '')
  String lastName;
  @JsonKey(defaultValue: '')
  String gender;
  @JsonKey(defaultValue: '')
  String image;
  @JsonKey(defaultValue: '')
  String token;

  User(this.id, this.username, this.email, this.firstName, this.lastName, this.gender, this.image, this.token);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
