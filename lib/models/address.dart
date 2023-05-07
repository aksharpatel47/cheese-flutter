import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/string_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:term_glyph/term_glyph.dart' as glyph;

part 'address.g.dart';

@JsonSerializable()
class Address with EquatableMixin {
  @JsonKey(name: "addrId")
  int addressId;
  int? personId;
  @JsonKey(name: "addrLn1")
  String? addressLine1;
  @JsonKey(name: "addrLn2")
  String? addressLine2;
  @JsonKey(name: "cityTown")
  String? city;
  String? stateProvince;
  String? postalCode;
  // final int countryId;
  String? countryCode;
  @JsonKey(name: "isSamparkOptOut")
  bool? samparkOptOut;
  @JsonKey(name: "isMailOptOut")
  bool? mailOptOut;
  @JsonKey(defaultValue: false)
  bool isAnyFamilyOptOut;
  @JsonKey(defaultValue: 0.0)
  double latitude;
  @JsonKey(defaultValue: 0.0)
  double longitude;
  @JsonKey(name: "type")
  String? addressTypeId;
  int? entityId;
  @JsonKey(defaultValue: ApiConstants.pendingStatus)
  String statusType;
  @JsonKey(defaultValue: '')
  String hierarchyId;
  @JsonKey(defaultValue: '')
  String hierarchyName;
  @JsonKey(defaultValue: [])
  List<int> familyMemberPersonId;
  bool get isPending => statusType == ApiConstants.pendingStatus;
  bool get isRejected => statusType == ApiConstants.rejectedStatus;
  bool get isApproved => statusType == ApiConstants.approveStatus;
  String get displayAddress {
    var adL1 = addressLine1;

    if ((samparkOptOut ?? false) || isAnyFamilyOptOut) {
      String b = glyph.glyphs.bullet;

      var adL1List = adL1?.split(" ") ?? [];
      if (adL1List.length > 1 && adL1List[1].isNotEmpty) {
        adL1List[1] = b + b + b + b;
      } else {
        if (adL1List.length > 2)
          adL1List[2] = b + b + b + b;
        else
          adL1List[0] = b + b + b + b;
      }
      adL1 = adL1List.join(" ");
    }

    return [adL1, addressLine2, city].where((i) => i.hasValue).join(", ") +
        "\n" +
        [
          stateProvince,
          postalCode,
        ].where((i) => i.hasValue).join(", ");
  }

  Color? get borderColor {
    if (statusType == ApiConstants.pendingStatus) return AppColors.backgroundColor;
    if (statusType == ApiConstants.rejectedStatus) return Colors.grey;
    return null;
  }

  Color? get bgColor {
    if (statusType == ApiConstants.pendingStatus) return AppColors.backgroundColor.withOpacity(0.04);
    if (statusType == ApiConstants.rejectedStatus) return Colors.grey.withOpacity(0.5);
    return null;
  }

  String get statusStr {
    if (statusType == ApiConstants.pendingStatus)
      return "Pending";
    else if (statusType == ApiConstants.rejectedStatus) return "Rejected";
    return "";
  }

  Color get statusStrColor {
    if (statusType == ApiConstants.pendingStatus)
      return AppColors.backgroundColor;
    else if (statusType == ApiConstants.rejectedStatus) return Colors.grey;
    return Colors.transparent;
  }

  Address(
    this.addressId,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.stateProvince,
    this.postalCode,
    this.samparkOptOut,
    this.isAnyFamilyOptOut,
    this.mailOptOut,
    this.latitude,
    this.longitude,
    this.addressTypeId,
    this.personId,
    this.countryCode,
    this.entityId, // this.countryId
    this.statusType,
    this.hierarchyId,
    this.hierarchyName,
    this.familyMemberPersonId,
  );

  Address copy() => Address.fromJson(jsonDecode(jsonEncode(this)));

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
  static const fromJsonFactory = _$AddressFromJson;

  @override
  List<Object?> get props => [/*personId,*/ addressId];
}

extension extraContactFunctions on List<Address> {
  List<Address> get sorted {
    return this
      ..sort((first, second) {
        if (first.statusType == second.statusType)
          return 0;
        else if (first.statusType == ApiConstants.approveStatus)
          return -1;
        else if (second.statusType == ApiConstants.approveStatus)
          return 1;
        else if (first.statusType == ApiConstants.rejectedStatus)
          return 1;
        else if (second.statusType == ApiConstants.rejectedStatus) return -1;
        return 0;
      });
  }

  List<Address> get approved => this.where((e) => e.isApproved).toList();

  List<Address> get pending => this.where((e) => e.isPending).toList();

  List<Address> get rejected => this.where((e) => e.isRejected).toList();
}
