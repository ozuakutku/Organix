import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '57d007c4e729423385791b6a57b403af';

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    final String url = 'https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$lon&key=$apiKey&lang=tr';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'][0];
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<dynamic>> getDailyForecast(double lat, double lon) async {
    final String url = 'https://api.weatherbit.io/v2.0/forecast/daily?lat=$lat&lon=$lon&key=$apiKey&lang=tr';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://www.weatherbit.io/static/img/icons/$iconCode.png';
  }
}
