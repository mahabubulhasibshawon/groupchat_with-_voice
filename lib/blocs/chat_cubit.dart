import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message.dart';
import '../services/websocket_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketService service;

  ChatCubit(this.service) : super(ChatState([])) {
    service.messages.listen((data) {
      addMessage(Message(textContent: data, isSentByUser: false, isAudio: false));
    });
  }

  void addMessage(Message message) {
    print("Adding message: isAudio=${message.isAudio}, audioBytes length=${message.audioBytes?.length}");
    final updatedMessages = List<Message>.from(state.messages)..add(message);
    emit(ChatState(updatedMessages));
    print("Message: isAudio=${message.isAudio}, audioBytes=${message.audioBytes}");

  }

  void sendMessage(String content) {
    service.sendMessage(content);
    addMessage(Message(textContent: content, isSentByUser: true, isAudio: false));
  }
  void sendAudioMessage(Uint8List audioBytes) {
    print("Adding audio message. Bytes length: ${audioBytes.length}");

    addMessage(Message(
      isSentByUser: true,
      isAudio: true,
      textContent: null, // No text content for audio messages
      audioBytes: audioBytes,
    ));
  }

  @override
  Future<void> close() {
    service.closeConnection();
    return super.close();
  }
}
