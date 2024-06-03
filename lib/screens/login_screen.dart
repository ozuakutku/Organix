import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';  // Güncellenmiş isim

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String? _email;
  String? _password;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: userCredential.user!)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hata: ${e.toString()}'),
        ));
      }
    }
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
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
                Image.asset(
                  'assets/images/organix_logo.png',
                  height: 300,
                ),
                CustomTextField(
                  label: 'E-posta',
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  validator: (value) => value!.isEmpty || !value.contains('@')
                      ? 'Lütfen geçerli bir e-posta adresi girin'
                      : null,
                ),
                CustomTextField(
                  label: 'Şifre',
                  obscureText: true,
                  onSaved: (value) => _password = value,
                  validator: (value) => value!.isEmpty
                      ? 'Lütfen şifrenizi girin'
                      : null,
                ),
                SizedBox(height: 20),
                PrimaryButton(
                  text: 'Giriş Yap',
                  onPressed: _login,
                  backgroundColor: Colors.lightGreen,
                ),
                TextButton(
                  onPressed: _navigateToForgotPassword,
                  child: Text('Şifrenizi mi unuttunuz?'),
                ),
                TextButton(
                  onPressed: _navigateToRegister,
                  child: Text('Hesabınız yok mu? Kayıt Olun'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
