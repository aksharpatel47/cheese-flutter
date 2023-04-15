import 'package:async/async.dart';
import 'package:flutter_app/api_clients/weather_client.dart';
import 'package:flutter_app/models/weather.dart';
import 'package:injectable/injectable.dart';

abstract class IWeatherService {
  Future<Result<Weather>> getWeather(String city);
}

@LazySingleton(as: IWeatherService)
class WeatherService implements IWeatherService {
  WeatherClient _weatherClient;

  WeatherService(this._weatherClient);

  @override
  Future<Result<Weather>> getWeather(String city) async => await _weatherClient.getWeather(city);
}
