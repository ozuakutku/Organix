import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '0d3258a43d1a41d3b3880823241605'; // WeatherAPI API anahtarınızı buraya ekleyin

  Future<Map<String, dynamic>> getWeatherByCoordinates(double latitude, double longitude) async {
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$latitude,$longitude';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
