import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_workshop/modules/weather/data/repositories/weather_repository.dart';
import 'package:reservation_workshop/modules/weather/domain/entities/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  WeatherCubit(this._repository) : super(WeatherInitial());

  Future<void> loadWeather(String city) async {
    if (isClosed) return;
    
    emit(WeatherLoading());
    try {
      final weather = await _repository.getWeather(city);
      if (!isClosed) {
        emit(WeatherLoaded(weather));
      }
    } catch (e) {
      if (!isClosed) {
        emit(WeatherError(e.toString()));
      }
    }
  }
}
