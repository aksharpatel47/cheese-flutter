import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

enum AppointmentStatus { none, active, upcoming }

@JsonSerializable()
class Appointment {
  final int appointmentId;
  String? appointmentTimeStamp;
  DateTime? get timeStamp {
    if (appointmentTimeStamp == null) {
      return null;
    }

    if (appointmentTimeStamp!.endsWith("Z")) {
      return DateTime.parse(appointmentTimeStamp!);
    }

    return DateTime.parse(appointmentTimeStamp! + "Z");
  }

  DateTime? get appointmentDateTime {
    if (timeStamp == null) {
      return null;
    }

    final lower = DateTime.now().subtract(Duration(hours: 12));

    if (timeStamp!.compareTo(lower) < 0) {
      return null;
    }

    return timeStamp;
  }

  AppointmentStatus get appointmentStatus {
    if (appointmentDateTime == null) {
      return AppointmentStatus.none;
    }

    final upper = DateTime.now().add(Duration(hours: 12));

    if (timeStamp!.compareTo(upper) > 0) {
      return AppointmentStatus.upcoming;
    }

    return AppointmentStatus.active;
  }

  Appointment(
      this.appointmentId,
      this.appointmentTimeStamp,
      );

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
