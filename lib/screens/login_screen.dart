import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart'; // HomeScreen import edildi
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

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
          content: Text('Error: ${e.toString()}'),
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
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value,
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Please enter a valid email address'
                    : null,
              ),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) => value!.isEmpty
                    ? 'Please enter your password'
                    : null,
              ),
              SizedBox(height: 20),
              PrimaryButton(
                text: 'Login',
                onPressed: _login,
              ),
              TextButton(
                onPressed: _navigateToForgotPassword,
                child: Text('Forgot Password?'),
              ),
              TextButton(
                onPressed: _navigateToRegister,
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
