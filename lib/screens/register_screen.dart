import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _firstName;
  String? _lastName;
  String? _email;
  DateTime? _birthDate;
  String? _occupation;
  String? _password;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> _register() async {
    await _requestPermissions();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'birthDate': _birthDate != null ? Timestamp.fromDate(_birthDate!) : null,
          'occupation': _occupation,
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 50),
                /*Image.asset(
                  'assets/images/organix_logo.png',
                  height: 300, // Logonun yüksekliğini artırdık
                  width: 300,  // Logonun genişliğini belirledik
                  fit: BoxFit.contain, // Görüntünün nasıl yerleşeceğini belirledik
                ),*/

                CustomTextField(
                  label: 'First Name',
                  onSaved: (value) => _firstName = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
                ),
                CustomTextField(
                  label: 'Last Name',
                  onSaved: (value) => _lastName = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
                ),
                CustomTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  validator: (value) => value!.isEmpty || !value.contains('@') ? 'Please enter a valid email address' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Birth Date (YYYY-MM-DD)'),
                  readOnly: true,
                  controller: _dateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _birthDate = pickedDate;
                        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  validator: (value) {
                    if (_birthDate == null) {
                      return 'Please enter your birth date';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Occupation',
                  onSaved: (value) => _occupation = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your occupation' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (value) => _password = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Register',
                  onPressed: _register,
                  backgroundColor: Colors.lightGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
