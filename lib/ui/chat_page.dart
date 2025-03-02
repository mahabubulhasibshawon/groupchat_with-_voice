import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/chat_cubit.dart';
import '../blocs/chat_state.dart';
import '../models/message.dart';
import '../services/voice_recorder.dart';

class ChatPage extends StatelessWidget {
  final VoiceRecorder _voiceRecorder = VoiceRecorder();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group Chat")),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];

                    return Align(
                      alignment: message.isSentByUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: message.isSentByUser ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: message.isAudio && message.audioBytes != null
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () async {
                                await _voiceRecorder.playAudio(message.audioBytes!);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.stop),
                              onPressed: () async {
                                await _voiceRecorder.stopAudio();
                              },
                            ),
                          ],
                        )
                            : Text(message.textContent ?? "Error: No text content"),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () async {
                    await _voiceRecorder.initRecorder();
                    final audioBytes = await _voiceRecorder.recordForTwoSeconds();
                    if (audioBytes != null) {
                      print("Sending audio message. Bytes length: ${audioBytes.length}");
                      context.read<ChatCubit>().sendAudioMessage(audioBytes);
                    } else {
                      print("Recording failed or returned null.");
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      context.read<ChatCubit>().sendMessage(message);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
