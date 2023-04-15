import 'package:json_annotation/json_annotation.dart';

part 'cheese_error.g.dart';

@JsonSerializable()
class CheeseError {
  @JsonKey(defaultValue: '')
  String message;

  CheeseError(this.message);

  factory CheeseError.fromJson(Map<String, dynamic> json) => _$CheeseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$CheeseErrorToJson(this);
}
