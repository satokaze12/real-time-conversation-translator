import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  late IO.Socket socket;
  static const String _baseUrl = 'http://localhost:3000';

  WebSocketService() {
    _initializeSocket();
  }

  void _initializeSocket() {
    socket = IO.io(
      _baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('WebSocket connected');
    });

    socket.onDisconnect((_) {
      print('WebSocket disconnected');
    });

    socket.onError((error) {
      print('WebSocket error: $error');
    });
  }

  void connect() {
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void joinConversation(String conversationId, String userId) {
    socket.emit('user:join', {
      'conversationId': conversationId,
      'userId': userId,
    });
  }

  void sendMessage(String conversationId, String text, String language) {
    socket.emit('message:send', {
      'conversationId': conversationId,
      'text': text,
      'language': language,
    });
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    socket.on('message:received', (data) {
      callback(data as Map<String, dynamic>);
    });
  }

  void onConnectionEstablished(Function() callback) {
    socket.on('connection:established', (_) {
      callback();
    });
  }
}
