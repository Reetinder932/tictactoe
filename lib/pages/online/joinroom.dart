import 'package:flutter/material.dart';
import 'package:tictactoe/pages/combined.dart';
import 'package:tictactoe/pages/online/createroom.dart';
import 'package:tictactoe/resources/socket_methods.dart';

class joinroom extends StatefulWidget {
  const joinroom({super.key});

  @override
  State<joinroom> createState() => _joinroomState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController namecontroller = TextEditingController();

TextEditingController idcontroller = TextEditingController();
final SocketMethods _socketMethods = SocketMethods();

class _joinroomState extends State<joinroom> {
  @override
  void _joinRoom() {
    if (_formKey.currentState!.validate()) {
      _socketMethods.joinroom(namecontroller.text, idcontroller.text);
      _socketMethods.joinRoomsuccess(context);
      _socketMethods.errorOccurred(context);
      _socketMethods.updateplayersstate(context);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Join Room",
              style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 40, color: Colors.blue)]),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: namecontroller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: idcontroller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintText: 'Token',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter valid Token";
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _joinRoom();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 120),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text("JOIN ROOM",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
