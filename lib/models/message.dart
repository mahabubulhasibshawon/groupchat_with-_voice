import 'dart:typed_data';

class Message {
  final String content;
  final bool isSentByUser;
  final bool isAudio;
  final Uint8List? audioBytes;

  Message({
    required this.content,
    required this.isSentByUser,
    this.isAudio = false,
    this.audioBytes,
  });
}
