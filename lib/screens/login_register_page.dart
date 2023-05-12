import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:deadline_tracker/services/auth.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  final _authService = GetIt.I<Auth>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  Future<void> _showErrorDialog(String? text) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(text ?? 'An unknown error occurred'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message);
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await _authService.createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        name: _controllerName.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message);
    }
  }

  Widget _entryField(
      {required String title,
      required TextEditingController controller,
      bool obscureText = false,
      bool enableSuggestions = true,
      bool autocorrect = true}) {
    return DecoratedContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        controller: controller,
        decoration: InputDecoration(labelText: title),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? _signInWithEmailAndPassword
            : _createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Register'));
  }

  Widget _loginOrRegisterButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead' : 'Login instead'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskMate'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _entryField(title: 'email', controller: _controllerEmail),
            isLogin ? SizedBox(height: 0) : SizedBox(height: 20),
            isLogin
                ? SizedBox(height: 0)
                : _entryField(title: 'name', controller: _controllerName),
            SizedBox(height: 20),
            _entryField(
                title: 'password',
                controller: _controllerPassword,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true),
            SizedBox(height: 20),
            _submitButton(),
            SizedBox(height: 10),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
