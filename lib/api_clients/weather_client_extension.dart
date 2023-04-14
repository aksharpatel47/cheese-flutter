part of 'weather_client.dart';

extension WeatherClientRepoFunctions on WeatherClient {
  Future<Result<Weather>> getWeather(String city) async {
    var resp = await client.getService<WeatherRemoteRepository>().getWeather(city);

    if (resp.isSuccessful && resp.body != null) {
      if (resp.body!.current != null && resp.body!.location != null && resp.body!.request != null)
        return Result.value(
            Weather(request: resp.body!.request!, location: resp.body!.location!, current: resp.body!.current!));
      else if (resp.body!.error != null)
        return Result.error(ServerFailure(resp.body!.error!.info, false));
      else
        return Result.error(InternalFailure(ErrorMessages.dataFail));
    } else {
      var error = resp.error;
      return Result.error(ServerFailure(error is WeatherError ? error.error.info : null, true));
    }
  }
}
