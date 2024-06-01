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
            ListTile(
              title: Text('First Name', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_firstName ?? ''),
            ),
            Divider(),
            ListTile(
              title: Text('Last Name', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_lastName ?? ''),
            ),
            Divider(),
            ListTile(
              title: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_email ?? ''),
            ),
            Divider(),
            ListTile(
              title: Text('Birth Date', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_birthDate != null ? DateFormat('yyyy-MM-dd').format(_birthDate!) : ''),
            ),
            Divider(),
            ListTile(
              title: Text('Occupation', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_occupation ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
