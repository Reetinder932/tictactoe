import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart%20';

// this class is made so that we donnot need to connect
// socket_client to socket again and again we only pass instance

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  //  Socket client constructor
  SocketClient._internal() {
    socket = IO.io('https://tictactoe-6ca8.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }
  // to make private instance avalable be make a function or getter
  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
// 
// 