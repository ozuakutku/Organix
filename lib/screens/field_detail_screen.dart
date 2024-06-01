import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/weather_service.dart';

class FieldDetailScreen extends StatelessWidget {
  final DocumentSnapshot field;

  FieldDetailScreen({required this.field});

  @override
  Widget build(BuildContext context) {
    final geoPoint = field['location'] as GeoPoint;
    final weatherService = WeatherService();

    return Scaffold(
      appBar: AppBar(
        title: Text(field['name']),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherService.getCurrentWeather(geoPoint.latitude, geoPoint.longitude),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data'));
          } else {
            final weather = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hava durumu bilgileri
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hava Durumu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Sıcaklık: ${weather['temp']}°C', style: TextStyle(fontSize: 18)),
                          Text('Hava: ${weather['weather']['description']}', style: TextStyle(fontSize: 18)),
                          Text('Nem: ${weather['rh']}%', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tarla detayları
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tarla Detayları', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Ad: ${field['name']}', style: TextStyle(fontSize: 18)),
                          Text('Boyut: ${field['size']}', style: TextStyle(fontSize: 18)),
                          Text('Konum: (${geoPoint.latitude}, ${geoPoint.longitude})', style: TextStyle(fontSize: 18)),
                          // Daha fazla tarla detayı eklenebilir
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
