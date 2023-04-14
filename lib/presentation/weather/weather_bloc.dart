import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/weather.dart';
import 'package:flutter_app/services/weather_service.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'weather_bloc.freezed.dart';

@injectable
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  IWeatherService _weatherService;

  WeatherBloc(this._weatherService) : super(WeatherState.empty(LoadingStatus.Initialized, null)) {
    on<WeatherEvent>((event, emit) async {
      await event.when(
        search: (String city) async {
          emit(WeatherState.empty(LoadingStatus.InProgress, null));

          final resp = await _weatherService.getWeather(city);

          if (resp.isError) {
            var failure = resp.asError!.error;
            if (failure is Failure) emit(WeatherState.empty(LoadingStatus.Error, failure));
          } else {
            emit(WeatherState.success(resp.asValue!.value));
          }
        },
      );
    });
  }
}

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState.success(Weather weather) = _Success;
  const factory WeatherState.empty(LoadingStatus loadingStatus, Failure? failure) = _Empty;
}

@freezed
class WeatherEvent with _$WeatherEvent {
  const factory WeatherEvent.search(String city) = _Search;
}
