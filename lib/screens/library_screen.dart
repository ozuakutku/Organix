import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kütüphane'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Text('Bu kısım ismail tarafından geliştirilecektir.'),
      ),
    );
  }
}
