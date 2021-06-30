import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';
import 'appointment.dart';
import 'contact.dart';
import 'email.dart';

part 'person.g.dart';

@JsonSerializable()
class Person extends Equatable {
  final int personId;
  final int personFamilyId;
  final String personName;
  final String personFirstName;
  final String personMiddleName;
  final String personLastName;
  final int age;
  final int maritalStatusTypeId;
  final String maritalStatus;
  final String comment;
  final String nativePlace;
  final bool activeStatus;
  final List<Address> address;
  final List<Contact> contact;
  final List<Email> email;
  final Appointment appointment;
  @JsonKey(defaultValue: "")
  final String personType;
  @JsonKey(defaultValue: 0)
  final int personTypeTagId;

  Person(
      this.personId,
      this.personName,
      this.personFirstName,
      this.personMiddleName,
      this.personLastName,
      this.address,
      this.contact,
      this.email,
      this.appointment,
      this.personFamilyId,
      this.age,
      this.maritalStatusTypeId,
      this.maritalStatus,
      this.comment,
      this.nativePlace,
      this.activeStatus,
      this.personType,
      this.personTypeTagId,
      );

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  List<Object> get props => [personId];
}
