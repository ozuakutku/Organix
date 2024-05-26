import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_screen.dart';

class AddFieldScreen extends StatefulWidget {
  @override
  _AddFieldScreenState createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  double? _latitude;
  double? _longitude;
  double? _size;
  String? _description;

  Future<void> _selectLocation() async {
    final selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        _latitude = selectedLocation.latitude;
        _longitude = selectedLocation.longitude;
      });
    }
  }

  Future<void> _addField() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
          await userDoc.collection('fields').add({
            'name': _name,
            'location': GeoPoint(_latitude!, _longitude!),
            'size': _size,
            'description': _description,
          });
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${e.toString()}'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Field'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Field Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the field name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Size (hectares)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the field size';
                  }
                  return null;
                },
                onSaved: (value) {
                  _size = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectLocation,
                child: Text(_latitude == null ? 'Select Location on Map' : 'Location: $_latitude, $_longitude'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Add Field'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
