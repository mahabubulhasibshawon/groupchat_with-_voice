class Message {
  final String content;
  final bool isSentByUser;
  final bool isAudio;

  Message({required this.content, required this.isSentByUser, this.isAudio = false});
}
