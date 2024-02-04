import 'package:custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:shadows/shadows.dart';
import 'package:tictactoe/pages/combined.dart';

import 'game.dart';

class Computer extends StatefulWidget {
  const Computer({Key? key});

  @override
  State<Computer> createState() => _ComputerState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController player1controller = TextEditingController();
TextEditingController player2controller = TextEditingController();

class _ComputerState extends State<Computer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "ENTER PLAYERS NAME",
              style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  shadows: [Shadow(blurRadius: 40, color: Colors.blue)]),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: player1controller,
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
                  hintText: 'Player 1 Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter player 1 name";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: player2controller,
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
                  hintText: 'Player 2 Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter player 2 name";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  // Navigate to the second page with slide animation
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Combined(
                          player1: player1controller.text,
                          player2: player2controller.text,
                          isoffline: true,
                          player1win: 0,
                          player2win: 0,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "Start Game",
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
