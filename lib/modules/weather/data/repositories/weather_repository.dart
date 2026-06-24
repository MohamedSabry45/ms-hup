import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reservation_workshop/modules/weather/domain/entities/weather.dart';

class WeatherRepository {
  static const String _apiKey = '8b1bca06c1bb4cf49e7131524262206';

  Future<Weather> getWeather(String location) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$location'),
      ).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        final locationData = data['location'];
        
        return Weather(
          location: locationData['name'] ?? location,
          condition: current['condition']['text'] ?? 'Clear',
          temperature: current['temp_c'].toDouble(),
          icon: _getWeatherIcon(current['condition']['code']),
        );
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      // Return default weather on error
      return Weather(
        location: location,
        condition: 'Clear',
        temperature: 32.0,
        icon: 'wb_sunny',
      );
    }
  }

  String _getWeatherIcon(int weatherCode) {
    // WeatherAPI.com condition codes
    if (weatherCode == 1000) return 'wb_sunny'; // Sunny
    if (weatherCode >= 1003 && weatherCode <= 1009) return 'cloud'; // Cloudy
    if (weatherCode >= 1030 && weatherCode <= 1035) return 'cloud'; // Mist/Fog
    if (weatherCode >= 1063 && weatherCode <= 1087) return 'ac_unit'; // Snow
    if (weatherCode >= 1150 && weatherCode <= 1207) return 'grain'; // Rain
    if (weatherCode >= 1273 && weatherCode <= 1282) return 'ac_unit'; // Blizzard
    if (weatherCode >= 2000 && weatherCode <= 2024) return 'thunderstorm'; // Thunderstorm
    return 'wb_sunny';
  }
}
