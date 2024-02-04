//we use room data provider as when there is any
// chnage i data while new user come then we can use this data
// in our dart files

import 'package:flutter/material.dart';
import 'package:tictactoe/models/player.dart';

class Roomdataprovider extends ChangeNotifier {
  //notifylistener
  //we use map ass room data is in map format
  List<String> _displayelement = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  int _filedboxes = 0;

  Map<String, dynamic> _roomdata = {};
  Player _player1 =
      Player(username: '', socketID: '', points: 0, playerType: 'X');
  Player _player2 =
      Player(username: '', socketID: '', points: 0, playerType: "O");
  Map<String, dynamic> get roomdata => _roomdata;
  Player get player1 => _player1;
  Player get player2 => _player2;
  int get filledboxes => _filedboxes;
  List<String> get displayelement => _displayelement;
  void updateRoomData(Map<String, dynamic> data) {
    _roomdata = data;
    notifyListeners();
  }

  void updateplayer1(Map<String, dynamic> player1data) {
    _player1 = Player.fromMap(player1data);
    notifyListeners();
  }

  void updateplayer2(Map<String, dynamic> player2data) {
    _player2 = Player.fromMap(player2data);
    notifyListeners();
  }

  void updatedisplayelements(int index, String choice) {
    _displayelement[index] = choice;
    _filedboxes += 1;
    notifyListeners();
  }

  void setfilledbox() {
    _filedboxes = 0;
  }
}
