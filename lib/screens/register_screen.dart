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
  String? _phoneNumber;
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
          'phone': _phoneNumber,
        });

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
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
                CustomTextField(
                  label: 'Ad',
                  onSaved: (value) => _firstName = value,
                  validator: (value) => value!.isEmpty ? 'Lütfen adınızı girin' : null,
                ),
                CustomTextField(
                  label: 'Soyad',
                  onSaved: (value) => _lastName = value,
                  validator: (value) => value!.isEmpty ? 'Lütfen soyadınızı girin' : null,
                ),
                CustomTextField(
                  label: 'E-posta',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  validator: (value) => value!.isEmpty || !value.contains('@') ? 'Lütfen geçerli bir e-posta adresi girin' : null,
                ),
                CustomTextField(
                  label: 'Doğum Tarihi (YYYY-AA-GG)',
                  controller: _dateController,
                  readOnly: true,
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
                      return 'Lütfen doğum tarihinizi girin';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                CustomTextField(
                  label: 'Meslek',
                  onSaved: (value) => _occupation = value,
                  validator: (value) => value!.isEmpty ? 'Lütfen mesleğinizi girin' : null,
                ),
                CustomTextField(
                  label: 'Telefon Numarası',
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _phoneNumber = value,
                  validator: (value) => value!.isEmpty ? 'Lütfen telefon numaranızı girin' : null,
                ),
                CustomTextField(
                  label: 'Şifre',
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (value) => _password = value,
                  validator: (value) => value!.isEmpty ? 'Lütfen şifrenizi girin' : null,
                ),
                CustomTextField(
                  label: 'Şifreyi Onayla',
                  obscureText: true,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Kayıt Ol',
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
