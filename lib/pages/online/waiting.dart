import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/utils/snackbar.dart';

class waiting_lobby extends StatefulWidget {
  const waiting_lobby({super.key});

  @override
  State<waiting_lobby> createState() => _waiting_lobbyState();
}

class _waiting_lobbyState extends State<waiting_lobby> {
  late TextEditingController roomIdcontroller;
  @override
  void initState() {
    // TODO: implement initState

    roomIdcontroller = TextEditingController(
        text: Provider.of<Roomdataprovider>(context, listen: false)
            .roomdata['_id']);
  }

  void dispose() {
    // TODO: implement dispose
    roomIdcontroller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Waiting For Player to join"),
          SizedBox(height: 20),
          Container(
            child: TextField(
              controller: roomIdcontroller,
              enabled: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: ''),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              copytoclipboard(context, roomIdcontroller.text);
            },
            child: Text("Copy ID"),
          )
        ],
      )),
    );
  }
}
