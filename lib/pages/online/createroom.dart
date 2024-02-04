import 'package:flutter/material.dart';
import 'package:tictactoe/pages/online/Room.dart';
import 'package:tictactoe/resources/socket_methods.dart';

class createroom extends StatefulWidget {
  const createroom({super.key});

  @override
  State<createroom> createState() => _createroomState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController namecontroller = TextEditingController();
final SocketMethods _socketMethods = SocketMethods();

class _createroomState extends State<createroom> {
  @override
  void _createRoom() {
    if (_formKey.currentState!.validate()) {
      _socketMethods.createRoomsuccess(context);
      _socketMethods.createroom(namecontroller.text);
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
              "Create Room",
              style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
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
            ElevatedButton(
              onPressed: () {
                //
                _createRoom();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 105),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text("CREATE ROOM",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
