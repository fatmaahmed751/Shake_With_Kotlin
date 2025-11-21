import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController {
  late WebSocketChannel channel;

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse("wss://ws.ifelse.io"),
    );
  }

  Stream get stream => channel.stream;

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void disconnect() {
    channel.sink.close();
  }
}
