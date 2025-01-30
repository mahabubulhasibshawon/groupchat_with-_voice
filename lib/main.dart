import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/chat_page.dart';
import 'services/websocket_service.dart';
import 'blocs/chat_cubit.dart';

void main() {
  final websocketService = WebSocketService('wss://chat.shohayok.com/ws');

  runApp(MyApp(websocketService: websocketService));
}

class MyApp extends StatelessWidget {
  final WebSocketService websocketService;

  MyApp({required this.websocketService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ChatCubit(websocketService),
        child: ChatPage(),
      ),
    );
  }
}
