import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/pages/choose.dart';
import 'package:tictactoe/register/login.dart';
import 'package:tictactoe/register/signup.dart';
import 'package:tictactoe/utils/colors.dart';
import 'package:tictactoe/pages/online/joinroom.dart';
import 'package:tictactoe/utils/colors.dart';
import 'package:tictactoe/pages/combined.dart';
import 'package:tictactoe/pages/computer.dart';
import 'package:tictactoe/pages/game.dart';
import 'package:tictactoe/pages/home.dart';
import 'package:tictactoe/pages/online/Room.dart';
import 'package:tictactoe/pages/online/createroom.dart';
import 'package:tictactoe/pages/splashscreen.dart';
import 'package:tictactoe/provider/room_data_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Roomdataprovider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: bgcolor,
          ),
          home: Splash()),
    );
  }
}
