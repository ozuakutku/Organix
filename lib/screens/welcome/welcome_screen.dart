import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/organix_logo1.png', height: 400),
            SizedBox(height: 20),
            Text(
              'Organix\'e Hoşgeldiniz',
              style: TextStyle(fontSize: 24, color: kPrimaryColor),
            ),
            SizedBox(height: 10),
            Text(
              'Organik ürünlerinizi kolayca yönetin',
              style: TextStyle(fontSize: 16, color: kPrimaryColor),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                  minimumSize: Size(150, 50)
              ),
              child: Text(
                'Giriş',
                style: TextStyle(
                  color: Colors.white, // Yazı rengi
                  fontSize: 18, // Yazı boyutu
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(150, 50)
              ),
              child: Text(
                'Kayıt',
                style: TextStyle(
                  color: Colors.white, // Yazı rengi
                  fontSize: 18, // Yazı boyutu
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
