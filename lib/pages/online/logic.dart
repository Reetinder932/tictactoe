import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/utils/dialogbox.dart';

class logic {
  void checkwinner(BuildContext context, Socket socketclient) {
    Roomdataprovider roomdataProvider =
        Provider.of<Roomdataprovider>(context, listen: false);

    String winner = '';
    if (roomdataProvider.displayelement[0] ==
            roomdataProvider.displayelement[1] &&
        roomdataProvider.displayelement[0] ==
            roomdataProvider.displayelement[2] &&
        roomdataProvider.displayelement[0] != '') {
      winner = roomdataProvider.displayelement[0];
      resetgame(context);
    }
    if (roomdataProvider.displayelement[3] ==
            roomdataProvider.displayelement[4] &&
        roomdataProvider.displayelement[3] ==
            roomdataProvider.displayelement[5] &&
        roomdataProvider.displayelement[3] != '') {
      winner = roomdataProvider.displayelement[3];
      resetgame(context);
    }

    if (roomdataProvider.displayelement[6] ==
            roomdataProvider.displayelement[7] &&
        roomdataProvider.displayelement[6] ==
            roomdataProvider.displayelement[8] &&
        roomdataProvider.displayelement[6] != '') {
      winner = roomdataProvider.displayelement[6];
      resetgame(context);
    }

    // Checking Column
    if (roomdataProvider.displayelement[0] ==
            roomdataProvider.displayelement[3] &&
        roomdataProvider.displayelement[0] ==
            roomdataProvider.displayelement[6] &&
        roomdataProvider.displayelement[0] != '') {
      winner = roomdataProvider.displayelement[0];
      resetgame(context);
    }
    if (roomdataProvider.displayelement[1] ==
            roomdataProvider.displayelement[4] &&
        roomdataProvider.displayelement[1] ==
            roomdataProvider.displayelement[7] &&
        roomdataProvider.displayelement[1] != '') {
      winner = roomdataProvider.displayelement[1];
      resetgame(context);
    }
    if (roomdataProvider.displayelement[2] ==
            roomdataProvider.displayelement[5] &&
        roomdataProvider.displayelement[2] ==
            roomdataProvider.displayelement[8] &&
        roomdataProvider.displayelement[2] != '') {
      winner = roomdataProvider.displayelement[2];
      resetgame(context);
    }

    // Checking Diagonal
    if (roomdataProvider.displayelement[0] ==
            roomdataProvider.displayelement[4] &&
        roomdataProvider.displayelement[0] ==
            roomdataProvider.displayelement[8] &&
        roomdataProvider.displayelement[0] != '') {
      winner = roomdataProvider.displayelement[0];
      resetgame(context);
    }
    if (roomdataProvider.displayelement[2] ==
            roomdataProvider.displayelement[4] &&
        roomdataProvider.displayelement[2] ==
            roomdataProvider.displayelement[6] &&
        roomdataProvider.displayelement[2] != '') {
      winner = roomdataProvider.displayelement[2];
      resetgame(context);
    } else if (roomdataProvider.filledboxes == 9) {
      winner = '';
      dialogbox(context, 'Draw', "Play Again");
      resetgame(context);
    }

    if (winner != '') {
      if (roomdataProvider.player1.playerType == winner) {
        socketclient.emit('winner', {
          'winnerSocketId': roomdataProvider.player1.socketID,
          'roomId': roomdataProvider.roomdata['_id'],
        });
      } else if (roomdataProvider.player2.playerType == winner) {
        socketclient.emit('winner', {
          'winnerSocketId': roomdataProvider.player2.socketID,
          'roomId': roomdataProvider.roomdata['_id'],
        });
      }
      if (roomdataProvider.player1.playerType == winner &&
          roomdataProvider.player1.points <
              roomdataProvider.roomdata['maxRounds']) {
        dialogbox(
            context, '${roomdataProvider.player1.username} won!', "Play Again");
      }
      if (roomdataProvider.player2.playerType == winner &&
          roomdataProvider.player2.points <
              roomdataProvider.roomdata['maxRounds']) {
        dialogbox(
            context, '${roomdataProvider.player2.username} won!', "Play Again");
      }
    }
  }

  void clearBoard(BuildContext context) {
    Roomdataprovider roomdataProvider =
        Provider.of<Roomdataprovider>(context, listen: false);

    for (int i = 0; i < roomdataProvider.displayelement.length; i++) {
      roomdataProvider.updatedisplayelements(i, '');
    }
    roomdataProvider.setfilledbox();
  }

  Future<void> resetgame(BuildContext context) async {
    Roomdataprovider roomdataProvider =
        Provider.of<Roomdataprovider>(context, listen: false);
    await Future.delayed(Duration(seconds: 3));
    for (int i = 0; i < roomdataProvider.displayelement.length; i++) {
      roomdataProvider.updatedisplayelements(i, '');
    }
    roomdataProvider.setfilledbox();
  }
}
