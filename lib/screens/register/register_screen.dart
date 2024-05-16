import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
    _confirmPasswordController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateInputs);
    _passwordController.removeListener(_validateInputs);
    _confirmPasswordController.removeListener(_validateInputs);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _errorMessage = '';

      if (_passwordController.text != _confirmPasswordController.text) {
        _errorMessage = 'Şifreler uyuşmuyor';
      } else if (_passwordController.text.length < 6) {
        _errorMessage = 'Şifre en az 6 karakter olmalı';
      } else if (_emailController.text.isEmpty) {
        _errorMessage = 'Email boş olamaz';
      } else if (!_isValidEmail(_emailController.text)) {
        _errorMessage = 'Geçersiz email adresi';
      }
    });
  }

  bool _isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kayıt Ol',
                style: TextStyle(fontSize: 24, color: kPrimaryColor),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Şifre',
                obscureText: true,
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Şifreyi Onayla',
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _errorMessage.isEmpty ? _register : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(200, 50),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'Şifre çok zayıf';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'Bu email zaten kullanılıyor';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Geçersiz email adresi';
        } else {
          _errorMessage = 'Bir hata oluştu: ${e.message}';
        }
      });
    }
  }
}
