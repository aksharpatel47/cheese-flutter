import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
class Entity with EquatableMixin {
  int entityId;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String code;
  int geoLevelId;
  int? parentEntityId;
  @JsonKey(defaultValue: '')
  String parentName;
  int? parentGeoLevelId;
  @JsonKey(defaultValue: [])
  List<Entity> childEntity;
  @JsonKey(defaultValue: false)
  bool suggestedDefault;

  Entity(this.entityId, this.name, this.code, this.geoLevelId, this.parentEntityId, this.parentName,
      this.parentGeoLevelId, this.childEntity, this.suggestedDefault);

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
  Map<String, dynamic> toJson() => _$EntityToJson(this);
  static const fromJsonFactory = _$EntityFromJson;

  Entity copy() => Entity.fromJson(jsonDecode(jsonEncode(this)));

  @override
  List<Object?> get props => [entityId];
}
