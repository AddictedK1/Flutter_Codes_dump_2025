import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/weather_data.dart';

class WeatherService {
  static Future<WeatherData> loadWeatherData(String city) async {
    final fileName = city.toLowerCase().replaceAll(' ', '_');
    final jsonString = await rootBundle.loadString(
      'assets/weather/$fileName.json',
    );
    final jsonData = json.decode(jsonString);
    return WeatherData.fromJson(jsonData);
  }

  static List<String> getCities() {
    return ['New York', 'London', 'Tokyo', 'Sydney', 'Dubai'];
  }
}
