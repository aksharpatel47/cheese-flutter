import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  WeatherRequest request;
  Location location;
  Current current;

  Weather({required this.request, required this.location, required this.current});

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class WeatherRequest {
  String type;
  String query;
  String language;
  String unit;

  WeatherRequest({this.type = '', this.query = '', this.language = '', this.unit = ''});

  factory WeatherRequest.fromJson(Map<String, dynamic> json) => _$WeatherRequestFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherRequestToJson(this);
}

@JsonSerializable()
class Location {
  String name;
  String country;
  String region;
  String lat;
  String lon;
  String localtime;

  Location({this.name = '', this.country = '', this.region = '', this.lat = '', this.lon = '', this.localtime = ''});

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Current {
  String observationTime;
  int temperature;
  int weatherCode;
  List<String> weatherIcons;
  List<String> weatherDescriptions;

  Current({
    this.observationTime = '',
    this.temperature = 0,
    this.weatherCode = 0,
    this.weatherIcons = const <String>[],
    this.weatherDescriptions = const <String>[],
  });

  factory Current.fromJson(Map<String, dynamic> json) => _$CurrentFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}
