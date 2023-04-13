import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/weather.dart';

part 'weather_remote_repository.chopper.dart';

@ChopperApi()
abstract class WeatherRemoteRepository extends ChopperService {
  static WeatherRemoteRepository create([ChopperClient? client]) => _$WeatherRemoteRepository(client);

  @Get(path: '/current')
  Future<Response<Weather>> getWeather(@Query('query') String city);
}
