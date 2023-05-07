import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/department.dart';
import 'package:flutter_app/models/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.g.dart';

@JsonSerializable()
class Position with EquatableMixin {
  int positionId;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String shortName;
  int roleId;
  String roleType;
  @JsonKey(name: 'dept')
  List<DeptWing> departments;
  int entityId;
  @JsonKey(defaultValue: '')
  String entityName;
  int geoLevelId;
  @JsonKey(defaultValue: [])
  List<Entity> assignedEntity;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Entity get entity => Entity(entityId, entityName, "", geoLevelId, null, "", null, [], false);

  Position(this.positionId, this.name, this.shortName, this.roleId, this.roleType, this.departments, this.entityId,
      this.entityName, this.geoLevelId, this.assignedEntity);

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);
  static const fromJsonFactory = _$PositionFromJson;

  @override
  List<Object?> get props => [positionId];
}
