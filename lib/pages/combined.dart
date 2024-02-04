import 'package:flutter/material.dart';
import 'package:tictactoe/pages/game.dart';

class Combined extends StatefulWidget {
  String player1;
  String player2;
  double player1win;
  double player2win;
  bool isoffline;

  Combined({
    required this.player1,
    required this.player2,
    required this.isoffline,
    required this.player1win,
    required this.player2win,
  });

  @override
  State<Combined> createState() => _CombinedState();
}

class _CombinedState extends State<Combined> {
  String currentPlayer = "";
  double player1winCount = 0;
  double player2winCount = 0;

  @override
  void initState() {
    super.initState();
    currentPlayer = widget.player1;
  }

  void switchPlayer() {
    setState(() {
      currentPlayer =
          currentPlayer == widget.player1 ? widget.player2 : widget.player1;
    });
  }

  void updateWinCount(String winner) {
    setState(() {
      if (winner == widget.player1) {
        player1winCount++;
      } else if (winner == widget.player2) {
        player2winCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: game(
              player1: widget.player1,
              player2: widget.player2,
              currentplayer: currentPlayer,
              isoffline: widget.isoffline,
              player1win: player1winCount,
              player2win: player2winCount,
              onMoveMade: switchPlayer,
              onGameEnd: updateWinCount,
            ),
          ),
        ],
      ),
    );
  }
}
