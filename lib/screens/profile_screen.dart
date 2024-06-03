import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;

  String? _firstName;
  String? _lastName;
  String? _email;
  DateTime? _birthDate;
  String? _occupation;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(widget.user.uid).get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    if (userData != null) {
      setState(() {
        _firstName = userData['firstName'];
        _lastName = userData['lastName'];
        _email = userData['email'];
        _birthDate = (userData['birthDate'] as Timestamp).toDate();
        _occupation = userData['occupation'];
      });
    }
  }

  Widget _buildProfileCard(String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen),
        ),
        subtitle: Text(value ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _firstName == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: <Widget>[
            _buildProfileCard('Ad', _firstName),
            _buildProfileCard('Soyad', _lastName),
            _buildProfileCard('E-posta', _email),
            _buildProfileCard('Doğum Tarihi', _birthDate != null ? DateFormat('yyyy-MM-dd').format(_birthDate!) : ''),
            _buildProfileCard('Meslek', _occupation),
          ],
        ),
      ),
    );
  }
}
