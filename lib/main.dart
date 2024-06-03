import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/market_screen/market_screen.dart'; // MarketScreen'i ekleyin
import 'screens/pdf_viewer_screen.dart'; // PdfViewerScreen'i ekleyin
import 'screens/chatbot_screen.dart'; // ChatbotScreen'i ekleyin
import 'screens/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organix',
      theme: ThemeData(
        primarySwatch: Colors.green,
        hintColor: Colors.orangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthCheck(),
        '/home': (context) => HomeScreen(user: FirebaseAuth.instance.currentUser!),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/market': (context) => MarketScreen(), // MarketScreen rotasını ekleyin
        '/pdf_viewer': (context) => PdfViewerScreen(), // PdfViewerScreen rotasını ekleyin
        '/chatbot': (context) => ChatbotScreen(user: FirebaseAuth.instance.currentUser!),
        '/library': (context) => LibraryScreen(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(user: snapshot.data!);
        } else {
          return WelcomeScreen();
        }
      },
    );
  }
}
