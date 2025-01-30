import 'dart:typed_data';


class Message {
  final bool isSentByUser;
  final bool isAudio;
  final String? textContent; // For text messages
  final Uint8List? audioBytes; // For audio messages

  Message({
    required this.isSentByUser,
    required this.isAudio,
    this.textContent,  // Nullable for audio messages
    this.audioBytes,   // Nullable for text messages
  });
}
