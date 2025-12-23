class WeatherData {
  final String city;
  final String country;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherData({
    required this.city,
    required this.country,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['city'],
      country: json['country'],
      current: CurrentWeather.fromJson(json['current']),
      hourly: (json['hourly'] as List)
          .map((item) => HourlyForecast.fromJson(item))
          .toList(),
      daily: (json['daily'] as List)
          .map((item) => DailyForecast.fromJson(item))
          .toList(),
    );
  }
}

class CurrentWeather {
  final int temperature;
  final String condition;
  final int humidity;
  final int windSpeed;
  final String sunrise;
  final String sunset;
  final String icon;

  CurrentWeather({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.icon,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temperature'],
      condition: json['condition'],
      humidity: json['humidity'],
      windSpeed: json['windSpeed'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      icon: json['icon'],
    );
  }
}

class HourlyForecast {
  final String time;
  final int temperature;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      temperature: json['temperature'],
      icon: json['icon'],
    );
  }
}

class DailyForecast {
  final String date;
  final int high;
  final int low;
  final String icon;

  DailyForecast({
    required this.date,
    required this.high,
    required this.low,
    required this.icon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'],
      high: json['high'],
      low: json['low'],
      icon: json['icon'],
    );
  }
}
