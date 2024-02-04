import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/pages/game.dart';
import 'package:tictactoe/provider/room_data_provider.dart';

class onlineCombined extends StatefulWidget {
  @override
  State<onlineCombined> createState() => _onlineCombinedState();
}

class _onlineCombinedState extends State<onlineCombined> {
  String currentPlayer = "";
  String player1 = "";
  String player2 = "";
  int player1win = 0;
  int player2win = 0;

  @override
  void initState() {
    super.initState();
    currentPlayer = player1;
  }

  void switchPlayer() {
    setState(() {
      currentPlayer = currentPlayer == player1 ? player2 : player1;
    });
  }

  void switchPlayer1(String win) {
    setState(() {
      currentPlayer = currentPlayer == player1 ? player2 : player1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Roomdataprovider roomdataprovider = Provider.of<Roomdataprovider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: game(
            player1: Provider.of<Roomdataprovider>(context).player1.username,
            player2: Provider.of<Roomdataprovider>(context).player2.username,
            isoffline: false,
            player1win: roomdataprovider.player1.points,
            player2win: roomdataprovider.player2.points,
            currentplayer: roomdataprovider.player1.playerType,
            onMoveMade: switchPlayer,
            onGameEnd: switchPlayer1,
          )),
        ],
      ),
    );
  }
}
