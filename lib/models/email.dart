import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

@JsonSerializable()
class Email {
  final int emailId;
  final String emailAddress;
  final int emailTypeId;
  final String emailTypeName;
  final bool emailOptOut;
  final int personId;

  const Email(
      this.emailAddress,
      this.emailTypeId,
      this.emailTypeName,
      this.emailOptOut,
      this.personId,
      this.emailId,
      );

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
  Map<String, dynamic> toJson() => _$EmailToJson(this);
}
