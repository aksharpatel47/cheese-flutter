import 'package:equatable/equatable.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';
import 'contact.dart';
import 'email.dart';

part 'person.g.dart';

@JsonSerializable()
class Person with EquatableMixin {
  final int personId;
  final String? prefix;
  @JsonKey(name: 'fName')
  final String? personFirstName;
  final String? suffix;
  @JsonKey(name: 'mName')
  final String? personMiddleName;
  @JsonKey(name: 'lName')
  final String? personLastName;
  final String? oName;

  String? bapsid;
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? get bapsidBasePref {
    return bapsIdBaseStr;
  }

  set bapsidBasePref(String? value) {
    bapsIdBaseStr = value;
  }

  String? bapsIdBaseStr;

  final int? age;
  final String? ageGroup;
  final int deptId;
  final int mandalId;
  @JsonKey(name: 'sCatId')
  final int? sCategoryId;
  @JsonKey(name: 'cRoot')
  final String? culturalRoot;
  int entityId;
  @JsonKey(defaultValue: '')
  String hierarchyId;
  @JsonKey(defaultValue: '')
  String hierarchyName;
  final int familyId;
  final String? comment;
  final String? maritalStatusType;
  @JsonKey(defaultValue: true)
  final bool? activeStatus;
  final String? gender;
  @JsonKey(defaultValue: [])
  final List<Address> address;
  @JsonKey(name: 'phone', defaultValue: [])
  final List<Contact> contact;
  @JsonKey(defaultValue: [])
  final List<Email> email;
  @JsonKey(defaultValue: false)
  final bool rqstToDel;
  final String? rqstToDelReason;
  @JsonKey(defaultValue: ApiConstants.pendingStatus)
  String statusType;

  // Extra items, not used by us but necessary for other apps
  String? drName;
  String? crfName;
  String? crlName;
  String? crmName;
  String? aGrade;
  @JsonKey(defaultValue: 0)
  int ageGroupYearS;
  @JsonKey(defaultValue: 0)
  int ageGroupYearE;
  String? ssoAccountStatus;
  String? ssoAccountError;
  String? sExamNo;
  // Up to here

  Person(
    this.personId,
    this.prefix,
    this.personFirstName,
    this.suffix,
    this.personMiddleName,
    this.personLastName,
    this.oName,
    this.bapsid,
    this.bapsIdBaseStr,
    this.age,
    this.ageGroup,
    this.deptId,
    this.mandalId,
    this.sCategoryId,
    this.culturalRoot,
    this.entityId,
    this.hierarchyId,
    this.hierarchyName,
    this.familyId,
    this.comment,
    this.maritalStatusType,
    this.activeStatus,
    this.gender,
    this.address,
    this.contact,
    this.email,
    this.rqstToDel,
    this.rqstToDelReason,
    this.statusType,
    this.drName,
    this.crfName,
    this.crlName,
    this.crmName,
    this.aGrade,
    this.ageGroupYearS,
    this.ageGroupYearE,
    this.ssoAccountStatus,
    this.ssoAccountError,
    this.sExamNo,
  );

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  static const fromJsonFactory = _$PersonFromJson;

  @override
  List<Object> get props => [personId];
}
