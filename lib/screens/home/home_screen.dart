import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/constants.dart';
import '../../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _errorMessage = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() async {
    try {
      Position position = await _determinePosition();
      final data = await _weatherService.getWeatherByCoordinates(position.latitude, position.longitude);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data: $e';
      });
      print('Failed to load weather data: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum hizmetlerinin etkin olup olmadığını kontrol edin.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Konum izni olup olmadığını kontrol edin.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Konum bilgisini alın.
    return await Geolocator.getCurrentPosition();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organix', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            if (_weatherData != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '${_weatherData!['location']['name']} Hava Durumu',
                      style: TextStyle(fontSize: 24, color: kPrimaryColor),
                    ),
                    Text(
                      '${_weatherData!['current']['temp_c']}°C',
                      style: TextStyle(fontSize: 40, color: kPrimaryColor),
                    ),
                    Text(
                      _weatherData!['current']['condition']['text'],
                      style: TextStyle(fontSize: 20, color: kPrimaryColor),
                    ),
                  ],
                ),
              )
            else if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
            else
              CircularProgressIndicator(),
            // Diğer içeriklerinizi burada ekleyebilirsiniz.
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listeler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hesap',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
