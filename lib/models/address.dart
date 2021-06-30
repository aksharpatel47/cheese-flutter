import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  final int addressId;
  final int personId;
  final String? addressLine1;
  final String? addressLine2;
  final String addressLine3;
  final String addressLine4;
  final String division;
  final String subdivision;
  final String? city;
  final String? stateProvince;
  final String? postalCode;
  final bool samparkOptOut;
  final bool mailOptOut;
  final double latitude;
  final double longitude;
  final int addressTypeId;
  final String addressTypeName;
  String get displayAddress =>
      [addressLine1, addressLine2, city].where((i) => i != null).join(", ") +
          "\n" +
          [
            stateProvince,
            postalCode,
          ].where((i) => i != null).join(", ");

  Address(
      this.addressId,
      this.addressLine1,
      this.addressLine2,
      this.addressLine3,
      this.addressLine4,
      this.division,
      this.subdivision,
      this.city,
      this.stateProvince,
      this.postalCode,
      this.samparkOptOut,
      this.mailOptOut,
      this.latitude,
      this.longitude,
      this.addressTypeId,
      this.addressTypeName,
      this.personId,
      );

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
