import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/pages/online/waiting.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/resources/socket_methods.dart';

class game extends StatefulWidget {
  String player1;
  String player2;
  double player1win;
  double player2win;
  bool isoffline;
  String currentplayer;
  VoidCallback onMoveMade;
  ValueChanged<String> onGameEnd; // Added callback for game end
  game({
    required this.player1,
    required this.player2,
    required this.currentplayer,
    required this.isoffline,
    required this.player1win,
    required this.player2win,
    required this.onMoveMade,
    required this.onGameEnd,
  });

  @override
  State<game> createState() => _gameState();
}

class _gameState extends State<game> {
  late List<String> _board;
  late String _player;
  String _winner = '';
  bool _over = false;
  int maxrounds = 5;

  SocketMethods _socketMethods = SocketMethods();

  Future<void> navigate(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    _resetgame();
  }

  @override
  void initState() {
    super.initState();
    _board = List.generate(9, (_) => "");
    _player = "X";
    _winner = "";
    _over = false;
    _socketMethods.updateroomlistener(context);
    _socketMethods.updateplayersstate(context);
    _socketMethods.tapped(context);
    _socketMethods.pointincrease(context);
    _socketMethods.endgame(context);
  }

  void _resetgame() {
    setState(() {
      _board = List.generate(9, (_) => "");
      _player = "X";
      _winner = "";
      _over = false;
    });
  }

  void _wincount() {
    if (_winner == "X") {
      widget.onGameEnd(widget.player1);
    } else if (_winner == "O") {
      widget.onGameEnd(widget.player2);
    }
  }

  bool _checkLineWinner(int a, int b, int c) {
    return _board[a] == _board[b] && _board[b] == _board[c] && _board[a] != "";
  }

  void makemove(int index) {
    if (_board[index] != "" || _over) {
      return;
    }

    setState(() {
      _board[index] = _player;
      if (_checkLineWinner(0, 1, 2) ||
          _checkLineWinner(3, 4, 5) ||
          _checkLineWinner(6, 7, 8) ||
          _checkLineWinner(0, 3, 6) ||
          _checkLineWinner(1, 4, 7) ||
          _checkLineWinner(2, 5, 8) ||
          _checkLineWinner(0, 4, 8) ||
          _checkLineWinner(2, 4, 6)) {
        _winner = _player;
        print("Winner: $_winner");
        _wincount();
        _over = true;
        _showWinnerDialog(context);
        navigate(context);
      } else {
        _player = _player == "X" ? "O" : "X";

        if (!_over && !_board.any((block) => block == "")) {
          _over = true;
          _winner = "DRAW";
          _showWinnerDialog(context);
          navigate(context);
        }
      }
    });
  }

  void _showWinnerDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      btnOkText: "Play Again",
      title: _winner == "X"
          ? widget.player1 + " WON"
          : _winner == "O"
              ? widget.player2 + " WON"
              : "DRAW",
      btnOkOnPress: () {
        _resetgame();
      },
    )..show();
  }

  void tapped(int index, Roomdataprovider roomdataprovider) {
    _socketMethods.gridtap(index, roomdataprovider.roomdata['_id'],
        roomdataprovider.displayelement);
  }

  @override
  Widget build(BuildContext context) {
    Roomdataprovider roomdataprovider = Provider.of<Roomdataprovider>(context);
    return Scaffold(
        body: widget.isoffline
            ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildScoreContainer(
                            "${widget.player1}: ${widget.player1win}"),
                        _buildTurnContainer("Turn: ${widget.currentplayer}"),
                        _buildScoreContainer(
                            "${widget.player2}: ${widget.player2win}"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (_board[index] == "") {
                                makemove(index);
                                _player = _player == "X" ? "X" : "O";
                                widget.onMoveMade();
                              }
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
                        }),
                  ),
                ],
              )
            : roomdataprovider.roomdata['isjoin']
                ? waiting_lobby()
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildScoreContainer(
                                "${roomdataprovider.player1.username}: ${roomdataprovider.player1.points}"),
                            _buildTurnContainer(
                                "Turn: ${roomdataprovider.roomdata['turn']['username']}"),
                            _buildScoreContainer(
                                "${roomdataprovider.player2.username}: ${roomdataprovider.player2.points}"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: roomdataprovider.roomdata['turn']
                                  ['socketID'] !=
                              _socketMethods.socketClient.id,
                          child: GridView.builder(
                              itemCount: 9,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () => tapped(index, roomdataprovider),
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
                                        duration: Duration(milliseconds: 200),
                                        child: Text(
                                          roomdataprovider
                                              .displayelement[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 100,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 40,
                                                color: roomdataprovider
                                                                .displayelement[
                                                            index] ==
                                                        "O"
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Text(
                          "MaxRounds: ${roomdataprovider.roomdata['maxRounds']}"),
                    ],
                  ));
  }

  Widget _buildScoreContainer(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.blue, // Change the background color as needed
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
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTurnContainer(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: Colors.green, // Change the background color as needed
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
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
