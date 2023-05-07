import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  Person profile;
  @JsonKey(defaultValue: const <Position>[])
  List<Position> positions;

  User(this.profile, this.positions);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
