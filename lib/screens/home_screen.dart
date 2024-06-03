import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/weather_service.dart';
import 'add_field_screen.dart';
import 'market_screen/market_screen.dart'; // MarketScreen'i import edin
import 'profile_screen.dart'; // ProfileScreen'i import edin
import 'chatbot_screen.dart'; // ChatbotScreen'i import edin
import 'library_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeContent(user: widget.user),
      MarketScreen(),
      ProfileScreen(user: widget.user),
      ChatbotScreen(user: widget.user),
      LibraryScreen(), // Kütüphane sekmesini ekleyin
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.lightGreen,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.lightGreen, width: 2) : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.lightGreen : Colors.white,
        ),
        padding: EdgeInsets.all(8),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildBottomNavigationBarItem(Icons.home, 'Ana Sayfa', 0),
          _buildBottomNavigationBarItem(Icons.shopping_cart, 'Market', 1),
          _buildBottomNavigationBarItem(Icons.person, 'Profil', 2),
          _buildBottomNavigationBarItem(Icons.smart_toy, 'Organix', 3),
          _buildBottomNavigationBarItem(Icons.library_books, 'Kütüphane', 4),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(color: Colors.lightGreen),
        unselectedLabelStyle: TextStyle(color: Colors.lightGreen),
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final User user;

  HomeContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tarlalarım',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('fields')
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          var fields = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: fields.length,
                            itemBuilder: (context, index) {
                              var field = fields[index];
                              return FutureBuilder<Map<String, dynamic>>(
                                future: WeatherService().getCurrentWeather(
                                  field['location'].latitude,
                                  field['location'].longitude,
                                ),
                                builder: (context, weatherSnapshot) {
                                  if (weatherSnapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (weatherSnapshot.hasError) {
                                    return Center(child: Text('Error: ${weatherSnapshot.error}'));
                                  } else if (!weatherSnapshot.hasData) {
                                    return Center(child: Text('No data'));
                                  } else {
                                    final weather = weatherSnapshot.data!;
                                    final weatherIconUrl = WeatherService().getWeatherIconUrl(weather['weather']['icon']);
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.network(
                                                  weatherIconUrl,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        field['name'],
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Sıcaklık: ${weather['temp']}°C',
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      Text(
                                                        'Hava: ${weather['weather']['description']}',
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      Text(
                                                        'Nem: ${weather['rh']}%',
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text('Boyut: ${field['size']} hektar', style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddFieldScreen()),
                            );
                          },
                          child: Text('Tarla Ekle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
