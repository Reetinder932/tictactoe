import 'package:flutter/material.dart';
import 'package:tictactoe/resources/socket_methods.dart';

class TournamentPage extends StatefulWidget {
  final String username;
  TournamentPage({required this.username});

  State<TournamentPage> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  @override
  SocketMethods _socketMethods = SocketMethods();
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Tournament Rooms',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildRoomCard('Room 1', [widget.username, 'Player 2']),
              _buildRoomCard('Room 2', ['Player 3', 'Player 4']),
              _buildRoomCard('Room 3', ['Player 5', 'Player 6']),
              _buildRoomCard('Room 4', ['Player 7', 'Player 8']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCard(String roomName, List<String> players) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              roomName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPlayerBox(players[0]),
            SizedBox(height: 10),
            _buildPlayerBox(players[1]),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerBox(String playerName) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        playerName,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
