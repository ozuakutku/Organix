import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50], // Aynı arka plan rengi
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50), // Boşluk ekleyerek daha iyi yerleşim
              Image.asset(
                'assets/images/organix_logo.png',
                height: 300, // Logonun boyutunu artırdık
                width: 300,  // Logonun genişliğini belirledik
                fit: BoxFit.contain, // Görüntünün nasıl yerleşeceğini belirledik
              ),
              SizedBox(height: 20),
              Text(
                'Organix\'e Hoşgeldiniz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 50),
              PrimaryButton(
                text: 'Giriş Yap',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                backgroundColor: Colors.lightGreen, // Aynı buton rengi
              ),
              SizedBox(height: 20), // Butonlar arasında boşluk
              PrimaryButton(
                text: 'Kayıt Ol',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                backgroundColor: Colors.lightGreen, // Aynı buton rengi
              ),
            ],
          ),
        ),
      ),
    );
  }
}
