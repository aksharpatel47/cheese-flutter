part of 'weather_client.dart';

extension WeatherClientRepoFunctions on WeatherClient {
  Future<Result<Weather>> getWeather(String city) async {
    var resp = await client.getService<WeatherRemoteRepository>().getWeather(city);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else
      return Result.error(ServerFailure(null, true));
  }
}
