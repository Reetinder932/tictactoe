import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tictactoe/pages/combined.dart';
import 'package:tictactoe/pages/game.dart';
import 'package:tictactoe/pages/home.dart';
import 'package:tictactoe/pages/online/logic.dart';
import 'package:tictactoe/pages/online/onlinecombined.dart';
import 'package:tictactoe/pages/online/waiting.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/register/login.dart';
import 'package:tictactoe/register/signup.dart';
import 'package:tictactoe/resources/socket_client.dart';
import 'package:tictactoe/utils/dialogbox.dart';
import 'package:tictactoe/utils/snackbar.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;
// send name data to server
  void createroom(String username) {
    if (username.isNotEmpty) {
      _socketClient.emit('createroom', {
        'username': username,
      });
    }
  }

  void jointournamentroom(String username) {
    if (username.isNotEmpty) {
      _socketClient.emit('joinTournamentRoom', {'username': username});
    }
  }

  void createuser(String username, String email, String password) {
    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _socketClient.emit('createuser',
          {'username': username, 'email': email, 'password': password});
    }
  }

  void loginuser(String username1, String password) {
    if (username1.isNotEmpty && password.isNotEmpty) {
      _socketClient
          .emit('loginuser', {'username1': username1, 'password': password});
    }
  }

  void loginsuccess(BuildContext context) {
    _socketClient.on('loginsuccess', (user) {
      saveUserDataLocally(user);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  void loginError(BuildContext context) {
    _socketClient.on('loginError', (data) {
      showsnackbar(context, data);
    });
  }

  void joinroom(String username, String roomId) {
    if (username.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit('joinroom', {'username': username, 'roomId': roomId});
    }
  }

  void createRoomsuccess(BuildContext context) {
    _socketClient.on('createroomsuccess', (room) {
      Provider.of<Roomdataprovider>(context, listen: false)
          .updateRoomData(room);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => onlineCombined()));
    });
  }

  void joinRoomsuccess(BuildContext context) {
    _socketClient.on('joinroomsuccess', (room) {
      Provider.of<Roomdataprovider>(context, listen: false)
          .updateRoomData(room);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => onlineCombined()));
    });
  }

  Future<void> saveUserDataLocally(dynamic user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userId', user['user'][0]['socketID']);
    prefs.setString('username', user['user'][0]['username']);
  }

  void createusersuccess(BuildContext context) {
    _socketClient.on("usercreatesuccess", (user) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    });
  }

  void joinTRoomsuccess(BuildContext context) {
    _socketClient.on('joinTroomsuccess', (room) {
      Provider.of<Roomdataprovider>(context, listen: false)
          .updateRoomData(room);
      showsnackbar(context, "Room joined Successfully");
    });
  }

  void joinTournamentRoomError(BuildContext context) {
    _socketClient.on('joinTournamentRoomError', (data) {
      showsnackbar(context, data);
    });
  }

  void errorOccurred(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showsnackbar(context, data);
    });
  }

  void updateplayersstate(BuildContext context) {
    _socketClient.on('updateplayers', (playerdata) {
      Provider.of<Roomdataprovider>(context, listen: false)
          .updateplayer1(playerdata[0]);
      Provider.of<Roomdataprovider>(context, listen: false)
          .updateplayer2(playerdata[1]);
    });
  }

  void updateroomlistener(BuildContext context) {
    _socketClient.on('updateroom', (data) {
      Provider.of<Roomdataprovider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void gridtap(int index, String roomId, List<String> displayelements) {
    if (displayelements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void tapped(BuildContext context) {
    _socketClient.on("tapped", (data) {
      Roomdataprovider roomdataprovider =
          Provider.of<Roomdataprovider>(context, listen: false);
      roomdataprovider.updatedisplayelements(data['index'], data['choice']);
      roomdataprovider.updateRoomData(data['room']);
      logic().checkwinner(context, socketClient);
    });
  }

  void pointincrease(BuildContext context) {
    _socketClient.on('increasepoint', (playerdata) {
      var roomdataprovider =
          Provider.of<Roomdataprovider>(context, listen: false);
      if (playerdata['socketID'] == roomdataprovider.player1.socketID) {
        roomdataprovider.updateplayer1(playerdata);
      } else {
        roomdataprovider.updateplayer2(playerdata);
      }
    });
  }

  void endgame(BuildContext context) {
    _socketClient.on('endgame', (playerdata) {
      dialogbox(context, '${playerdata['username']} won the game', "Go Home");
      Future.delayed(
        Duration(seconds: 3),
        () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Home(),
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
        },
      );
    });
  }
}
// data goes from indexjs to listeners they give it to providers and providers use it in 
// pages