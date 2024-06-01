import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'weather_service.dart';

class ChatbotService {
  final String _apiKey = 'AIzaSyBTroZiQPoLAH7s-AO483KMH7KdJDTzcho';
  late final GenerativeModel _model;
  final WeatherService _weatherService = WeatherService();

  ChatbotService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
  }

  Future<String?> sendMessage(String message, String userId, String fieldId, String? pdfPath) async {
    try {
      // Kullanıcının tarlasının bilgilerini Firestore'dan çek
      DocumentSnapshot fieldSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fields')
          .doc(fieldId)
          .get();

      // Null kontrolü
      if (!fieldSnapshot.exists || fieldSnapshot.data() == null) {
        throw Exception('Field data not found');
      }

      Map<String, dynamic> fieldData = fieldSnapshot.data() as Map<String, dynamic>;
      GeoPoint location = fieldData['location'];

      // Konum bilgilerini al
      double latitude = location.latitude;
      double longitude = location.longitude;

      // Hava durumu ve iklim verilerini al
      Map<String, dynamic> weatherData = await _weatherService.getCurrentWeather(latitude, longitude);

      // PDF verisini base64 olarak oku
      String? pdfBase64;
      if (pdfPath != null) {
        final pdfBytes = await File(pdfPath).readAsBytes();
        pdfBase64 = base64Encode(pdfBytes);
      }

      // Chatbot'a mesaj gönderme
      final prompt = """
        $message

        Tarla Konumu: Enlem $latitude, Boylam $longitude
        İklim Koşulları: ${weatherData['weather']['description']}
        Sıcaklık: ${weatherData['temp']}°C
        Nem: ${weatherData['rh']}%

        ${pdfBase64 != null ? 'Toprak Analizi Raporu: $pdfBase64' : ''}
      """;

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text;
    } catch (e) {
      throw Exception('Failed to get response from Chatbot API: $e');
    }
  }
}
