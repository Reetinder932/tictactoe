import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tictactoe/resources/socket_methods.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void pressed() {
    _socketMethods.createusersuccess(context);
    _socketMethods.errorOccurred(context);
    _socketMethods.createuser(
        usernameController.text, emailController.text, passwordController.text);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pressed,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
