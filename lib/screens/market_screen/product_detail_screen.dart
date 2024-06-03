import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatelessWidget {
  final DocumentSnapshot product;

  ProductDetailScreen({required this.product});

  Future<void> _removeProduct(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(product.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün başarıyla kaldırıldı')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }

  void _sendMessage(BuildContext context, String ownerId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
    String phoneNumber = userDoc['phone'];

    // Telefon numarasının başında "+" işareti olduğundan emin olun
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+$phoneNumber';
    }

    String message = 'Ürününüzle ilgileniyorum: ${product['name']}';
    Uri url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('WhatsApp açılamadı'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(product['imageUrl']),
            SizedBox(height: 20),
            Text(
              product['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Fiyat: ${product['price']} USD',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Miktar: ${product['quantity']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Açıklama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              product['description'],
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            if (product['ownerId'] == user!.uid) ...[
              ElevatedButton(
                onPressed: () {
                  _removeProduct(context);
                },
                child: Text('Ürünü Kaldır'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                _sendMessage(context, product['ownerId']);
              },
              child: Text('Satıcıya WhatsApp Mesajı Gönder'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
            ),
          ],
        ),
      ),
    );
  }
}
