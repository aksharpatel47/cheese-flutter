import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

enum EmailEditMode { approved, pending, rejected }

@JsonSerializable()
class Email with EquatableMixin {
  @JsonKey(defaultValue: 0)
  int emailId;
  String? get emailAddress {
    if (!(isOptOut))
      return email;
    else {
      String e = emailMasked ?? "";
      e = e.replaceAll("#", "*");
      e = e.replaceAll("XX", "**");
      e = e.replaceAll("xx", "**");

      String tE = "";
      var y = e.split("");
      for (int i = 0; i < y.length; i++) {
        if (i == 0 || i == y.length - 1) {
          tE += y[i];
        } else {
          tE += y[i - 1] == '*' && y[i].toLowerCase() == 'x' ? "*" : y[i];
        }
      }

      String nE = "";
      var x = tE.split("");
      for (int i = 0; i < x.length; i++) {
        if (i == 0)
          nE = x[i];
        else {
          nE += x[i - 1] == '*' && x[i] == '*' ? "" : x[i];
        }
      }
      nE = nE.replaceAll("*", Constants.bullet + Constants.bullet + Constants.bullet);
      return nE;
    }
  }

  String? email;
  @JsonKey(name: "type")
  String? emailTypeId;
  @JsonKey(defaultValue: false)
  bool isOptOut;

  /// DON'T USE "isEmailOptOut" field in code, its just for serialization purpose
  set isEmailOptOut(bool? value) {
    if (value ?? false) isOptOut = value ?? false;
  }

  /// DON'T USE "isEmailOptOut" field in code, its just for serialization purpose
  bool? get isEmailOptOut => isOptOut;
  String? emailMasked;
  final int? personId;
  @JsonKey(defaultValue: true)
  bool active;
  @JsonKey(defaultValue: false)
  bool isEdit;
  // int? oldEmailId;
  @JsonKey(name: 'originalEmailId')
  int? originalEmailId;
  @JsonKey(defaultValue: false, name: "isVerified")
  bool isVerifiedDoNotUse;
  @JsonKey(ignore: true)
  bool get isVerified => isVerifiedDoNotUse /* || emailTypeId != ApiConstants.primaryEmailTypeId*/;
  // @JsonKey(defaultValue: false)
  // bool isDisabled;
  @JsonKey(defaultValue: ApiConstants.pendingStatus)
  String statusType;

  Email(this.email, this.emailTypeId, this.isOptOut, this.personId, this.emailId, this.emailMasked,
      {this.active = true,
      this.isEdit = false,
      this.isVerifiedDoNotUse = false,
      // this.isDisabled = false,
      this.statusType = ApiConstants.approveStatus});

  Email copy() {
    return Email.fromJson(jsonDecode(jsonEncode(this)));
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
      if (emailId == originalEmailId || originalEmailId == 0 || originalEmailId == null)
        return "Pending";
      else
        return "Edit Pending";
    } else if (statusType == ApiConstants.rejectedStatus) {
      if (emailId == originalEmailId || originalEmailId == 0 || originalEmailId == null)
        return "Rejected";
      else
        return "Edit Rejected";
    }
    if (!isVerified && emailTypeId == ApiConstants.primaryEmailTypeId) return "Not Verified";
    return "";
  }

  Color get statusStrColor {
    if (statusType == ApiConstants.pendingStatus)
      return AppColors.backgroundColor;
    else if (statusType == ApiConstants.rejectedStatus) return Colors.grey;
    if (!isVerified && emailTypeId == ApiConstants.primaryEmailTypeId) return Colors.grey.withOpacity(0.5);
    return Colors.black;
  }

  bool get isNotSubItem => originalEmailId == null || originalEmailId == 0 || originalEmailId == emailId;

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
  Map<String, dynamic> toJson() => _$EmailToJson(this);
  static const fromJsonFactory = _$EmailFromJson;

  @override
  List<Object?> get props => [emailId, personId];
}

// extension extraEmailFunctions on List<Email> {
//   List<Email> byMode(EmailEditMode mode) {
//     if (mode == EmailEditMode.approved)
//       return this
//           .sortEmailPreview()
//           .where((c) =>
//               c.statusType == ApiConstants.approveStatus && this.pendingListFor(c.emailId).isEmpty && c.isNotSubItem)
//           .toList();
//     else if (mode == EmailEditMode.pending)
//       return this
//           .sortEmailPreview()
//           .where((c) =>
//               (c.statusType == ApiConstants.pendingStatus || this.pendingListFor(c.emailId).isNotEmpty) &&
//               c.isNotSubItem)
//           .toList();
//     else if (mode == EmailEditMode.rejected)
//       return this
//           .sortEmailPreview()
//           .where((c) => c.statusType == ApiConstants.rejectedStatus && c.isNotSubItem)
//           .toList();
//     else
//       return [];
//   }
//
//   List<Email> get previewEmails => this
//       .where((e) => TestConstants.showRejected || e.statusType != ApiConstants.rejectedStatus)
//       .toList()
//       .sortEmailPreview()
//       .where((e) => e.originalEmailId == 0 || e.originalEmailId == null || e.originalEmailId == e.emailId)
//       .toList();
//
//   List<Email> get editEmails => this
//       .where((e) => TestConstants.showRejected || e.statusType != ApiConstants.rejectedStatus)
//       .toList()
//       .sortEmailEdit()
//       .where((e) => e.originalEmailId == 0 || e.originalEmailId == null || e.originalEmailId == e.emailId)
//       .toList();
//
//   List<Email> get mailableEmails => this
//       .where((e) => TestConstants.showRejected || e.statusType != ApiConstants.rejectedStatus)
//       .toList()
//       .sortEmailPreview()
//       .where((e) =>
//           // (e.originalEmailId == 0 || e.originalEmailId == null || e.originalEmailId == e.emailId) &&
//           e.statusType != ApiConstants.rejectedStatus)
//       .toList();
//
//   List<Email> sortEmailPreview() => this
//     ..sort((first, second) {
//       var firstPendingList = this.pendingListFor(first.emailId);
//       var firstRejectList = this.rejectedListFor(first.emailId);
//
//       var secondPendingList = this.pendingListFor(second.emailId);
//       var secondRejectList = this.rejectedListFor(second.emailId);
//
//       bool bothVerified = first.isVerified && second.isVerified;
//       bool bothApproved =
//           first.statusType == ApiConstants.approveStatus && second.statusType == ApiConstants.approveStatus;
//       bool bothListEmpty =
//           firstPendingList.isEmpty && firstRejectList.isEmpty && secondPendingList.isEmpty && secondRejectList.isEmpty;
//
//       //primary phone top priority
//       if (first.emailTypeId == ApiConstants.homePhoneTypeId) return -1;
//       if (second.emailTypeId == ApiConstants.homePhoneTypeId) return 1;
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
//   List<Email> sortEmailEdit() => this;
//
//   List<Email> pendingListFor(int emailId) => this
//       .where((e) => e.originalEmailId == emailId && e.emailId != emailId && e.statusType == ApiConstants.pendingStatus)
//       .toList();
//
//   List<Email> rejectedListFor(int emailId) => TestConstants.showRejected
//       ? this
//           .where((e) =>
//               e.originalEmailId == emailId && e.emailId != emailId && e.statusType == ApiConstants.rejectedStatus)
//           .toList()
//       : [];
//
//   Color borderColor(Email c) {
//     if (pendingListFor(c.emailId).isNotEmpty || c.statusType == ApiConstants.pendingStatus)
//       return AppColors.backgroundColor;
//     else if (rejectedListFor(c.emailId).isNotEmpty || c.statusType == ApiConstants.rejectedStatus) return Colors.grey;
//     return Colors.transparent;
//   }
//
//   Color bgColor(Email c) {
//     if (pendingListFor(c.emailId).isNotEmpty || c.statusType == ApiConstants.pendingStatus)
//       return AppColors.backgroundColor.withOpacity(0.04);
//     else if (rejectedListFor(c.emailId).isNotEmpty || c.statusType == ApiConstants.rejectedStatus)
//       return Colors.grey.withOpacity(0.04);
//     return Colors.transparent;
//   }
// }

// extension statusType on EmailEditMode {
//   Color get borderColor {
//     if (this == EmailEditMode.pending) return AppColors.backgroundColor;
//     if (this == EmailEditMode.rejected) return Colors.grey;
//     return Colors.transparent;
//   }
//
//   Color get bgColor {
//     if (this == EmailEditMode.pending) return AppColors.backgroundColor.withOpacity(0.04);
//     if (this == EmailEditMode.rejected) return Colors.grey.withOpacity(0.04);
//     return Colors.transparent;
//   }
//
//   String get statusName {
//     if (this == EmailEditMode.pending) return "Pending";
//     if (this == EmailEditMode.rejected) return "Rejected";
//     return "";
//   }
//
//   String get actionName {
//     if (this == EmailEditMode.pending) return "Approve";
//     if (this == EmailEditMode.rejected) return "Reject";
//     if (this == EmailEditMode.approved) return "Verify";
//     return "";
//   }
//
//   Color get actionColor {
//     if (this == EmailEditMode.pending) return AppColors.backgroundColor;
//     if (this == EmailEditMode.rejected) return Colors.black;
//     if (this == EmailEditMode.approved) return Color.fromRGBO(7, 91, 144, 1.0);
//     return Colors.black;
//   }
// }
