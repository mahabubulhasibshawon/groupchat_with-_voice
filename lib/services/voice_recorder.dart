import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _audioPath;

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
    await Permission.microphone.request();
  }

  Future<Uint8List?> recordForTwoSeconds() async {
    _audioPath = '${Directory.systemTemp.path}/voice_message.aac';
    await _recorder.startRecorder(toFile: _audioPath);

    // Wait for 2 seconds
    await Future.delayed(Duration(seconds: 2));

    // Stop recording and retrieve bytes
    await _recorder.stopRecorder();
    if (_audioPath != null) {
      final file = File(_audioPath!);
      return file.readAsBytesSync();
    }
    return null;
  }

  void dispose() {
    _recorder.closeRecorder();
  }
}
