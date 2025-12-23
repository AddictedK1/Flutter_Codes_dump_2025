import 'package:flutter/material.dart';
import 'models/weather_data.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Display',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String selectedCity = 'New York';
  WeatherData? weatherData;
  bool isLoading = true;
  bool isCelsius = true;

  @override
  void initState() {
    super.initState();
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    setState(() => isLoading = true);
    try {
      final data = await WeatherService.loadWeatherData(selectedCity);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  int convertTemp(int tempCelsius) {
    return isCelsius ? tempCelsius : (tempCelsius * 9 / 5 + 32).round();
  }

  String get tempUnit => isCelsius ? '°C' : '°F';

  LinearGradient getBackgroundGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
        );
      case 'partly cloudy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF607D8B), Color(0xFF90A4AE)],
        );
      case 'cloudy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF546E7A), Color(0xFF78909C)],
        );
      case 'rainy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF455A64), Color(0xFF607D8B)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        );
    }
  }

  IconData getWeatherIcon(String iconName) {
    switch (iconName) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly_cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.umbrella;
      case 'clear_night':
        return Icons.nightlight_round;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || weatherData == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: getBackgroundGradient('sunny')),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: getBackgroundGradient(weatherData!.current.condition),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // City Selector and Temperature Toggle
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // City Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          value: selectedCity,
                          dropdownColor: Colors.blueGrey[800],
                          underline: const SizedBox(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          items: WeatherService.getCities().map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedCity = newValue;
                              });
                              loadWeatherData();
                            }
                          },
                        ),
                      ),
                      // Temperature Unit Toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => isCelsius = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isCelsius
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '°C',
                                  style: TextStyle(
                                    color: isCelsius
                                        ? Colors.blue[900]
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => isCelsius = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: !isCelsius
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '°F',
                                  style: TextStyle(
                                    color: !isCelsius
                                        ? Colors.blue[900]
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Current Weather
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        '${weatherData!.city}, ${weatherData!.country}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        getWeatherIcon(weatherData!.current.icon),
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${convertTemp(weatherData!.current.temperature)}$tempUnit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        weatherData!.current.condition,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Weather Details Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherDetail(
                            Icons.water_drop,
                            '${weatherData!.current.humidity}%',
                            'Humidity',
                          ),
                          _buildWeatherDetail(
                            Icons.air,
                            '${weatherData!.current.windSpeed} km/h',
                            'Wind',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Sunrise and Sunset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherDetail(
                            Icons.wb_twilight,
                            weatherData!.current.sunrise,
                            'Sunrise',
                          ),
                          _buildWeatherDetail(
                            Icons.nights_stay,
                            weatherData!.current.sunset,
                            'Sunset',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Hourly Forecast
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          'Hourly Forecast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: weatherData!.hourly.length,
                          itemBuilder: (context, index) {
                            final hour = weatherData!.hourly[index];
                            return _buildHourlyCard(hour);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // 5-Day Forecast
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          '5-Day Forecast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: weatherData!.daily.length,
                          itemBuilder: (context, index) {
                            final day = weatherData!.daily[index];
                            return _buildDailyCard(day);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildHourlyCard(HourlyForecast hour) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hour.time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Icon(getWeatherIcon(hour.icon), color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(
            '${convertTemp(hour.temperature)}$tempUnit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCard(DailyForecast day) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Icon(getWeatherIcon(day.icon), color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${convertTemp(day.high)}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' / ${convertTemp(day.low)}°',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
