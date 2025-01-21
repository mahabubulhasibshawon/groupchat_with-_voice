import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(String url) : channel = WebSocketChannel.connect(Uri.parse(url));

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  // send voice
  void sendAudioBytes(Uint8List audioBytes) {
    channel.sink.add(audioBytes);
  }


  Stream<dynamic> get messages => channel.stream;

  void closeConnection() {
    channel.sink.close();
  }
}
