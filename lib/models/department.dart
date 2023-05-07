import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/geo_level.dart';
import 'package:json_annotation/json_annotation.dart';

part 'department.g.dart';

@JsonSerializable()
class Department with EquatableMixin {
  final int deptId;
  final int? divId;
  @JsonKey(name: 'name', defaultValue: '')
  final String deptName;
  @JsonKey(name: 'code', defaultValue: '')
  final String deptCode;
  @JsonKey(defaultValue: 'e')
  final String wing;
  final int? parentDeptId;
  final bool? isSatsangActivityDept;
  final bool? isAdministrationDept;
  final bool? isApplicationDept;

  Department(this.deptId, this.divId, this.deptName, this.deptCode, this.wing, this.parentDeptId,
      this.isSatsangActivityDept, this.isAdministrationDept, this.isApplicationDept);

  DeptWing toDeptWing() {
    return DeptWing.fromJson(jsonDecode(jsonEncode(this)));
  }

  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
  static const fromJsonFactory = _$DepartmentFromJson;

  @override
  List<Object?> get props => [deptId];
}

@JsonSerializable()
class Mandal with EquatableMixin {
  final int mandalId;
  @JsonKey(defaultValue: '')
  final String mandalName;

  Mandal(this.mandalId, this.mandalName);

  factory Mandal.fromJson(Map<String, dynamic> json) => _$MandalFromJson(json);
  Map<String, dynamic> toJson() => _$MandalToJson(this);
  static const fromJsonFactory = _$MandalFromJson;

  @override
  List<Object?> get props => [mandalId];
}

@JsonSerializable()
class DeptMandal {
  int deptId;
  @JsonKey(defaultValue: '')
  String deptName;
  int mandalId;
  @JsonKey(defaultValue: '')
  String mandalName;

  DeptMandal(this.deptId, this.deptName, this.mandalId, this.mandalName);

  Mandal toMandal() {
    return Mandal.fromJson(jsonDecode(jsonEncode(this)));
  }

  factory DeptMandal.fromJson(Map<String, dynamic> json) => _$DeptMandalFromJson(json);
  Map<String, dynamic> toJson() => _$DeptMandalToJson(this);
  static const fromJsonFactory = _$DeptMandalFromJson;
}

@JsonSerializable()
class SCategory with EquatableMixin {
  final int sCatId;
  @JsonKey(defaultValue: '')
  final String sCategoryName;
  bool isSelected;
  SCategory(this.sCatId, this.sCategoryName, {this.isSelected = false});

  factory SCategory.fromJson(Map<String, dynamic> json) => _$SCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SCategoryToJson(this);
  static const fromJsonFactory = _$SCategoryFromJson;

  @override
  List<Object?> get props => [sCatId];
}

@JsonSerializable()
class DeptSCat with EquatableMixin {
  final int deptId;
  @JsonKey(defaultValue: '')
  final String deptName;
  final int sCatId;
  @JsonKey(defaultValue: '')
  final String sCategoryName;

  DeptSCat(this.deptId, this.deptName, this.sCatId, this.sCategoryName);

  SCategory toSCat() {
    return SCategory.fromJson(jsonDecode(jsonEncode(this)));
  }

  factory DeptSCat.fromJson(Map<String, dynamic> json) => _$DeptSCatFromJson(json);
  Map<String, dynamic> toJson() => _$DeptSCatToJson(this);
  static const fromJsonFactory = _$DeptSCatFromJson;

  @override
  List<Object?> get props => [sCatId];
}

@JsonSerializable()
class DeptTag with EquatableMixin {
  final int deptId;
  @JsonKey(defaultValue: '')
  final String deptName;
  @JsonKey(name: 'samparkTagId')
  final int tagId;
  @JsonKey(defaultValue: '', name: 'samparkTagCode')
  final String tagCode;

  DeptTag(this.deptId, this.deptName, this.tagId, this.tagCode);

  factory DeptTag.fromJson(Map<String, dynamic> json) => _$DeptTagFromJson(json);
  Map<String, dynamic> toJson() => _$DeptTagToJson(this);
  static const fromJsonFactory = _$DeptTagFromJson;

  @override
  List<Object?> get props => [tagId];
}

@JsonSerializable()
class DeptWing {
  final int deptId;
  @JsonKey(name: 'name', defaultValue: '')
  final String deptName;
  @JsonKey(name: 'code', defaultValue: '')
  final String deptCode;
  @JsonKey(defaultValue: 'e')
  final String wing;

  DeptWing(this.deptId, this.deptName, this.deptCode, this.wing);

  factory DeptWing.fromJson(Map<String, dynamic> json) => _$DeptWingFromJson(json);
  Map<String, dynamic> toJson() => _$DeptWingToJson(this);
  static const fromJsonFactory = _$DeptWingFromJson;
}

@JsonSerializable()
class DeptGeoLevel {
  final int deptId;
  @JsonKey(defaultValue: 999)
  final int geoLevelId;
  @JsonKey(name: "order", defaultValue: "999")
  final String orderString;
  @JsonKey(includeToJson: false, includeFromJson: true)
  int get order => int.tryParse(orderString) ?? 999;
  @JsonKey(defaultValue: false)
  final bool isActive;
  @JsonKey(defaultValue: '')
  String geoLevelName = "";

  DeptGeoLevel copy() => DeptGeoLevel.fromJson(jsonDecode(jsonEncode(this)));

  DeptGeoLevel(this.deptId, this.geoLevelId, this.orderString, this.isActive);

  factory DeptGeoLevel.fromJson(Map<String, dynamic> json) => _$DeptGeoLevelFromJson(json);
  Map<String, dynamic> toJson() => _$DeptGeoLevelToJson(this);
  static const fromJsonFactory = _$DeptGeoLevelFromJson;

  factory DeptGeoLevel.fromGeoLevel(GeoLevel geoLevel, int deptId) =>
      DeptGeoLevel(deptId, geoLevel.geoLevelId, geoLevel.orderString, true);
}
