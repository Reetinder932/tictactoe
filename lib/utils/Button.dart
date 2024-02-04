import 'package:flutter/material.dart';
import 'package:tictactoe/pages/choose.dart';
import 'package:tictactoe/pages/computer.dart';
import 'package:tictactoe/pages/online/Room.dart';
import 'package:tictactoe/register/login.dart';
import 'package:tictactoe/tournament/tounrmant_page.dart';

class btn extends StatelessWidget {
  final String page;
  final String name;

  const btn({Key? key, required this.page, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Widget dpage;
        double h;
        if (page == "Room") {
          dpage = Room();
        } else if (page == "choose") {
          dpage = choose();
        } else {
          return;
        }

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => dpage,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(name, style: TextStyle(fontSize: 20)),
    );
  }
}
