import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geo_level.g.dart';

@JsonSerializable()
class GeoLevel with EquatableMixin {
  @JsonKey(defaultValue: 99)
  final int divId;
  @JsonKey(defaultValue: 999)
  final int geoLevelId;
  @JsonKey(defaultValue: "Unknown")
  final String geoLevel;
  @JsonKey(name: "order", defaultValue: "999")
  final String orderString;
  @JsonKey(ignore: true)
  int get order => int.tryParse(orderString) ?? 999;

  GeoLevel(this.divId, this.geoLevelId, this.geoLevel, this.orderString);

  factory GeoLevel.fromJson(Map<String, dynamic> json) => _$GeoLevelFromJson(json);
  Map<String, dynamic> toJson() => _$GeoLevelToJson(this);
  static const fromJsonFactory = _$GeoLevelFromJson;

  @override
  List<Object?> get props => [divId, geoLevelId];
}
