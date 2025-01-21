import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message.dart';
import '../services/websocket_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketService service;

  ChatCubit(this.service) : super(ChatState([])) {
    service.messages.listen((data) {
      addMessage(Message(content: data, isSentByUser: false));
    });
  }

  void addMessage(Message message) {
    final updatedMessages = List<Message>.from(state.messages)..add(message);
    emit(ChatState(updatedMessages));
  }

  void sendMessage(String content) {
    service.sendMessage(content);
    addMessage(Message(content: content, isSentByUser: true));
  }

  void sendAudioMessage(Uint8List audioBytes) {
    service.sendAudioBytes(audioBytes);
    addMessage(Message(content: "[Voice Message]", isSentByUser: true, isAudio: true));
  }



  @override
  Future<void> close() {
    service.closeConnection();
    return super.close();
  }
}
