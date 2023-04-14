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
class WeatherResponse {
  WeatherRequest? request;
  Location? location;
  Current? current;
  bool? success;
  WeatherErrorDetail? error;

  WeatherResponse(this.request, this.location, this.current, this.success, this.error);

  factory WeatherResponse.fromJson(Map<String, dynamic> json) => _$WeatherResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherResponseToJson(this);
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

  String get fullLocation => [name, region, country].join(", ");

  Location({this.name = '', this.country = '', this.region = '', this.lat = '', this.lon = '', this.localtime = ''});

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Current {
  @JsonKey(name: 'observation_time')
  String observationTime;
  int temperature;
  @JsonKey(name: 'weather_code')
  int weatherCode;
  @JsonKey(name: 'weather_icons')
  List<String> weatherIcons;
  @JsonKey(name: 'weather_descriptions')
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

@JsonSerializable()
class WeatherError {
  @JsonKey(defaultValue: false)
  bool success;
  WeatherErrorDetail error;

  WeatherError(this.success, this.error);

  factory WeatherError.fromJson(Map<String, dynamic> json) => _$WeatherErrorFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherErrorToJson(this);
}

@JsonSerializable()
class WeatherErrorDetail {
  @JsonKey(defaultValue: 0)
  int code;
  @JsonKey(defaultValue: '')
  String type;
  @JsonKey(defaultValue: '')
  String info;

  WeatherErrorDetail(this.code, this.type, this.info);

  factory WeatherErrorDetail.fromJson(Map<String, dynamic> json) => _$WeatherErrorDetailFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherErrorDetailToJson(this);
}
