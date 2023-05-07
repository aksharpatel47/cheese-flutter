import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

enum PhoneEditMode { approved, pending, rejected }

@JsonSerializable()
class Contact with EquatableMixin {
  @JsonKey(name: "phoneId", defaultValue: 0)
  int contactNumberId;
  int? personId;
  String? isdCode;
  @JsonKey(name: "phone")
  String? phone;

  @JsonKey(ignore: true)
  String get contactNumber {
    if (!(phoneCallOptOut ?? false) || isEdit) {
      if (phone == null)
        return "";
      else {
        String _phone = "";
        for (int i = 0; i < phone!.length; i++) {
          _phone += phone![i];
          if (i == 2 || i == 5) _phone += " - ";
        }
        return _phone;
      }
    } else {
      if (phoneMasked == null)
        return "";
      else {
        String _phone = "";
        String _pMask = phoneMasked
                ?.toLowerCase()
                .replaceAll("x", Constants.bullet)
                .replaceAll("#", Constants.bullet)
                .replaceAll("*", Constants.bullet) ??
            "";
        for (int i = 0; i < _pMask.length; i++) {
          _phone += _pMask[i];
          if (i == 2 || i == 5) _phone += " - ";
        }
        return _phone;
      }
    }
  }

  set contactNumber(String phone) {
    this.phone = phone.replaceAll("-", "").replaceAll(" ", "");
  }

  @JsonKey(name: "type")
  String? contactNumberTypeId;
  @JsonKey(name: "isCallOptOut")
  bool? phoneCallOptOut;
  @JsonKey(name: "isSmsOptOut")
  bool? get smsOptOut => phoneCallOptOut;
  set smsOptOut(bool? value) {
    if (value == true) {
      phoneCallOptOut = value;
    }
  }

  bool? get isOptOut => phoneCallOptOut;

  set isOptOut(bool? value) {
    if (value == true) {
      phoneCallOptOut = value;
      smsOptOut = value;
    }
  }

  @JsonKey(defaultValue: true)
  bool active;
  @JsonKey(defaultValue: false)
  bool isEdit;
  // int? oldPhoneId;
  @JsonKey(name: 'originalPhoneId')
  int? originalPhoneId;
  @JsonKey(defaultValue: false, name: "isVerified")
  bool isVerifiedDoNotUse;
  @JsonKey(ignore: true)
  bool get isVerified => isVerifiedDoNotUse /* || contactNumberTypeId != ApiConstants.primaryPhoneTypeId*/;
  // @JsonKey(defaultValue: false)
  // bool isDisabled;
  @JsonKey(defaultValue: ApiConstants.pendingStatus)
  String statusType;
  String? phoneMasked;

  Contact(this.contactNumberId, this.isdCode, this.phone, this.contactNumberTypeId, this.phoneCallOptOut,
      /*this.smsOptOut,*/ this.personId, this.phoneMasked,
      {this.active = true,
      this.isEdit = false,
      this.isVerifiedDoNotUse = false,
      // this.isDisabled = false,
      this.statusType = ApiConstants.approveStatus});

  Contact copy() {
    return Contact.fromJson(jsonDecode(jsonEncode(this)));
  }

  Color get statusColor {
    if (statusType == ApiConstants.pendingStatus)
      return AppColors.backgroundColor;
    else if (statusType == ApiConstants.rejectedStatus) return Colors.grey;
    // else if (!isVerified) return Color.fromRGBO(7, 91, 144, 1.0);
    return Colors.black;
  }

  Color get statusBulletColor {
    if (statusType == ApiConstants.pendingStatus)
      return AppColors.backgroundColor;
    else if (statusType == ApiConstants.rejectedStatus) return Colors.grey;
    // else if (!isVerified) return Color.fromRGBO(7, 91, 144, 1.0);
    return Colors.black54;
  }

  String get statusStr {
    if (statusType == ApiConstants.pendingStatus) {
      if (contactNumberId == originalPhoneId || originalPhoneId == 0 || originalPhoneId == null)
        return "Pending";
      else
        return "Edit Pending";
    } else if (statusType == ApiConstants.rejectedStatus) {
      if (contactNumberId == originalPhoneId || originalPhoneId == 0 || originalPhoneId == null)
        return "Rejected";
      else
        return "Edit Rejected";
    }
    if (!isVerified && contactNumberTypeId == ApiConstants.primaryPhoneTypeId) return "Not Verified";
    return "";
  }

  Color get statusStrColor {
    if (statusType == ApiConstants.pendingStatus)
      return AppColors.backgroundColor;
    else if (statusType == ApiConstants.rejectedStatus) return Colors.grey;
    if (!isVerified && contactNumberTypeId == ApiConstants.primaryPhoneTypeId) return Colors.grey.withOpacity(0.5);
    return Colors.black;
  }

  bool get isNotSubItem => originalPhoneId == null || originalPhoneId == 0 || originalPhoneId == contactNumberId;

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
  static const fromJsonFactory = _$ContactFromJson;

  @override
  List<Object?> get props => [personId, contactNumberId];
}
//
// extension extraContactFunctions on List<Contact> {
//   List<Contact> byMode(PhoneEditMode mode) {
//     if (mode == PhoneEditMode.approved)
//       return this
//           .sortContactPreview()
//           .where((c) =>
//               c.statusType == ApiConstants.approveStatus &&
//               this.pendingListFor(c.contactNumberId).isEmpty &&
//               c.isNotSubItem)
//           .toList();
//     else if (mode == PhoneEditMode.pending)
//       return this
//           .sortContactPreview()
//           .where((c) =>
//               (c.statusType == ApiConstants.pendingStatus || this.pendingListFor(c.contactNumberId).isNotEmpty) &&
//               c.isNotSubItem)
//           .toList();
//     else if (mode == PhoneEditMode.rejected)
//       return this
//           .sortContactPreview()
//           .where((c) => c.statusType == ApiConstants.rejectedStatus && c.isNotSubItem)
//           .toList();
//     else
//       return [];
//   }
//
//   List<Contact> get previewContacts => this
//       .where((e) => TestConstants.showRejected || e.statusType != ApiConstants.rejectedStatus)
//       .toList()
//       .sortContactPreview()
//       .where((e) => e.originalPhoneId == 0 || e.originalPhoneId == null || e.originalPhoneId == e.contactNumberId)
//       .toList();
//
//   List<Contact> get editContacts => this
//       .where((e) => TestConstants.showRejected || e.statusType != ApiConstants.rejectedStatus)
//       .toList()
//       .sortContactEdit()
//       .where((e) => e.originalPhoneId == 0 || e.originalPhoneId == null || e.originalPhoneId == e.contactNumberId)
//       .toList();
//
//   List<Contact> get callableContacts => this
//       .where((e) => TestConstants.showRejected || e.statusType != ApiConstants.rejectedStatus)
//       .toList()
//       .sortContactPreview()
//       .where((e) =>
//           // (e.originalPhoneId == 0 || e.originalPhoneId == null || e.originalPhoneId == e.contactNumberId) &&
//           e.statusType != ApiConstants.rejectedStatus)
//       .toList();
//
//   List<Contact> sortContactPreview() => this
//     ..sort((first, second) {
//       var firstPendingList = this.pendingListFor(first.contactNumberId);
//       var firstRejectList = this.rejectedListFor(first.contactNumberId);
//
//       var secondPendingList = this.pendingListFor(second.contactNumberId);
//       var secondRejectList = this.rejectedListFor(second.contactNumberId);
//
//       bool bothVerified = first.isVerified && second.isVerified;
//       bool bothApproved =
//           first.statusType == ApiConstants.approveStatus && second.statusType == ApiConstants.approveStatus;
//       bool bothListEmpty =
//           firstPendingList.isEmpty && firstRejectList.isEmpty && secondPendingList.isEmpty && secondRejectList.isEmpty;
//
//       //primary phone top priority
//       if (first.contactNumberTypeId == ApiConstants.homePhoneTypeId) return -1;
//       if (second.contactNumberTypeId == ApiConstants.homePhoneTypeId) return 1;
//
//       //both have same priority
//       if (bothVerified && bothApproved && bothListEmpty) return 0;
//
//       //different priority because of verified status
//       if (first.isVerified && !second.isVerified)
//         return -1;
//       else if (!first.isVerified && second.isVerified) return 1;
//
//       //different priority because of approval status
//       if (first.statusType == ApiConstants.approveStatus && second.statusType != ApiConstants.approveStatus)
//         return -1;
//       else if (first.statusType == ApiConstants.pendingStatus && second.statusType == ApiConstants.rejectedStatus)
//         return -1;
//       else if (first.statusType != ApiConstants.approveStatus && second.statusType == ApiConstants.approveStatus)
//         return 1;
//       else if (first.statusType == ApiConstants.rejectedStatus && second.statusType == ApiConstants.pendingStatus)
//         return 1;
//
//       //different priority because of pending items
//       if (firstRejectList.isEmpty && firstPendingList.isEmpty && secondPendingList.isNotEmpty)
//         return -1;
//       else if (firstPendingList.isNotEmpty && secondPendingList.isEmpty && secondRejectList.isEmpty) return 1;
//
//       //different priority because of pending items
//       if (firstRejectList.isEmpty && secondRejectList.isNotEmpty)
//         return -1;
//       else if (firstRejectList.isNotEmpty && secondRejectList.isEmpty) return 1;
//
//       return 0;
//     });
//
//   List<Contact> sortContactEdit() => this;
//
//   List<Contact> pendingListFor(int contactNumberId) => this
//       .where((e) =>
//           e.originalPhoneId == contactNumberId &&
//           e.contactNumberId != contactNumberId &&
//           e.statusType == ApiConstants.pendingStatus)
//       .toList();
//
//   List<Contact> rejectedListFor(int contactNumberId) => TestConstants.showRejected
//       ? this
//           .where((e) =>
//               e.originalPhoneId == contactNumberId &&
//               e.contactNumberId != contactNumberId &&
//               e.statusType == ApiConstants.rejectedStatus)
//           .toList()
//       : [];
//
//   Color borderColor(Contact c) {
//     if (pendingListFor(c.contactNumberId).isNotEmpty || c.statusType == ApiConstants.pendingStatus)
//       return AppColors.backgroundColor;
//     else if (rejectedListFor(c.contactNumberId).isNotEmpty || c.statusType == ApiConstants.rejectedStatus)
//       return Colors.grey;
//     return Colors.transparent;
//   }
//
//   Color bgColor(Contact c) {
//     if (pendingListFor(c.contactNumberId).isNotEmpty || c.statusType == ApiConstants.pendingStatus)
//       return AppColors.backgroundColor.withOpacity(0.04);
//     else if (rejectedListFor(c.contactNumberId).isNotEmpty || c.statusType == ApiConstants.rejectedStatus)
//       return Colors.grey.withOpacity(0.04);
//     return Colors.transparent;
//   }
// }
//
// extension statusType on PhoneEditMode {
//   Color get borderColor {
//     if (this == PhoneEditMode.pending) return AppColors.backgroundColor;
//     if (this == PhoneEditMode.rejected) return Colors.grey;
//     return Colors.transparent;
//   }
//
//   Color get bgColor {
//     if (this == PhoneEditMode.pending) return AppColors.backgroundColor.withOpacity(0.04);
//     if (this == PhoneEditMode.rejected) return Colors.grey.withOpacity(0.04);
//     return Colors.transparent;
//   }
//
//   String get statusName {
//     if (this == PhoneEditMode.pending) return "Pending";
//     if (this == PhoneEditMode.rejected) return "Rejected";
//     return "";
//   }
//
//   String get actionName {
//     if (this == PhoneEditMode.pending) return "Approve";
//     if (this == PhoneEditMode.rejected) return "Reject";
//     if (this == PhoneEditMode.approved) return "Verify";
//     return "";
//   }
//
//   Color get actionColor {
//     if (this == PhoneEditMode.pending) return AppColors.backgroundColor;
//     if (this == PhoneEditMode.rejected) return Colors.black;
//     if (this == PhoneEditMode.approved) return Color.fromRGBO(7, 91, 144, 1.0);
//     return Colors.black;
//   }
// }
