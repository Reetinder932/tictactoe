import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:tictactoe/pages/computer.dart';

class Easy extends StatefulWidget {
  final String difficulty;

  Easy({required this.difficulty});

  @override
  State<Easy> createState() => _EasyState();
}

class _EasyState extends State<Easy> {
  late List<String> _board;
  late String _player;
  String _winner = '';
  bool _over = false;

  Future<void> navigate(BuildContext context, String winner) async {
    await Future.delayed(Duration(seconds: 1));
    if (winner == "O") {
      _resetGame(winner);
      _makeBotMove();
    } else if (winner == "X") {
      _resetGame(winner);
    } else {
      _resetGame(winner);
      _makeBotMove();
    }
  }

  @override
  void initState() {
    super.initState();
    _board = List.generate(9, (_) => "");
    _player = "X";
    _winner = "";
    _over = false;
    _makeBotMove();
  }

  void _resetGame(String turn) {
    setState(() {
      _board = List.generate(9, (_) => "");
      if (turn == "X") {
        _player = "O";
      } else {
        _player = "X";
      }
      _winner = "";
      _over = false;
    });
  }

  bool _checkLineWinner(int a, int b, int c) {
    return _board[a] == _board[b] && _board[b] == _board[c] && _board[a] != "";
  }

  bool _checkWin(String player) {
    return (_checkLineWinner(0, 1, 2) ||
        _checkLineWinner(3, 4, 5) ||
        _checkLineWinner(6, 7, 8) ||
        _checkLineWinner(0, 3, 6) ||
        _checkLineWinner(1, 4, 7) ||
        _checkLineWinner(2, 5, 8) ||
        _checkLineWinner(0, 4, 8) ||
        _checkLineWinner(2, 4, 6));
  }

  void _makeBotMove() {
    List<int> emptyPositions = [];
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == "") {
        emptyPositions.add(i);
      }
    }

    if (emptyPositions.isNotEmpty) {
      Random random = Random();
      int randomIndex;

      if (widget.difficulty == "Easy") {
        randomIndex = emptyPositions[random.nextInt(emptyPositions.length)];
      } else {
        randomIndex = _getSmartMove(emptyPositions);
      }

      Timer(Duration(milliseconds: 500), () {
        if (!_over) {
          setState(() {
            _board[randomIndex] = _player;
            gameresult();
            _player = _player == "X" ? "O" : "X";
          });
        }
      });
    }
  }

  int _getSmartMove(List<int> emptyPositions) {
    if (widget.difficulty == "Medium") {
      Random random = Random();
      return emptyPositions[random.nextInt(emptyPositions.length)];
    } else {
      int randomIndex = emptyPositions[0];

      for (int i = 0; i < emptyPositions.length; i++) {
        int index = emptyPositions[i];
        _board[index] = "O";
        if (_checkWin("O")) {
          _board[index] = "";
          return index;
        }
        _board[index] = "";
      }

      for (int i = 0; i < emptyPositions.length; i++) {
        int index = emptyPositions[i];
        _board[index] = "X";
        if (_checkWin("X")) {
          _board[index] = "";
          return index;
        }
        _board[index] = "";
      }

      return randomIndex;
    }
  }

  void _makePlayerMove(int index) {
    if (_board[index] == "" && !_over) {
      setState(() {
        _board[index] = _player;
        gameresult();
        _player = _player == "O" ? "X" : "O";
        if (!_over) {
          _makeBotMove();
          gameresult();
        }
      });
    }
  }

  void gameresult() {
    if (_checkLineWinner(0, 1, 2) ||
        _checkLineWinner(3, 4, 5) ||
        _checkLineWinner(6, 7, 8) ||
        _checkLineWinner(0, 3, 6) ||
        _checkLineWinner(1, 4, 7) ||
        _checkLineWinner(2, 5, 8) ||
        _checkLineWinner(0, 4, 8) ||
        _checkLineWinner(2, 4, 6)) {
      _winner = _player == "X" ? "X" : "O";
      _over = true;
      _showWinnerDialog(context);
      navigate(context, _winner);
    } else {
      if (!_over && !_board.any((block) => block == "")) {
        _over = true;
        _winner = "DRAW";
        _showWinnerDialog(context);
        navigate(context, _winner);
      }
    }
  }

  void _showWinnerDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      btnOkText: "Play Again",
      title: _winner == "O"
          ? "User WON"
          : _winner == "X"
              ? "Computer WON"
              : "DRAW",
      btnOkOnPress: () {},
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTurnContainer(_player),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () {
                    _makePlayerMove(index);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey.withOpacity(0.1),
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          _board[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 100,
                            shadows: [
                              Shadow(
                                blurRadius: 40,
                                color: _board[index] == "X"
                                    ? Colors.blue
                                    : Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnContainer(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Colors.green,
        // borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text == "O" ? "Turn: User" : "Turn: Computer",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
