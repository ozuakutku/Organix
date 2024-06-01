import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AIScreen extends StatelessWidget {
  final User user;

  AIScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Ekranı'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Text('AI Ekranı', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
