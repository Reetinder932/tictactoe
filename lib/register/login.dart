import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tictactoe/resources/socket_methods.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void pressed() {
    _socketMethods.loginsuccess(context);
    _socketMethods.loginError(context);
    _socketMethods.loginuser(usernameController.text, passwordController.text);
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
