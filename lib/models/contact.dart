import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final int contactNumberId;
  final int personId;
  final String contactNumber;
  final int contactNumberTypeId;
  final String contactNumberTypeName;
  final bool phoneCallOptOut;
  final bool smsOptOut;

  Contact(
      this.contactNumberId,
      this.contactNumber,
      this.contactNumberTypeId,
      this.contactNumberTypeName,
      this.phoneCallOptOut,
      this.smsOptOut,
      this.personId,
      );

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
