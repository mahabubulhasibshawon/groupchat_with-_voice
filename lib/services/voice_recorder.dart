import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      print("✅ Microphone permission granted.");
      return true;
    } else if (status.isDenied) {
      print("❌ Microphone permission denied.");
    } else if (status.isPermanentlyDenied) {
      print("⚠️ Microphone permission permanently denied. Open settings.");
      openAppSettings();
    }
    return false;
  }


  Future<Uint8List?> recordForTwoSeconds() async {
    try {
      print("Starting 2-second recording...");
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/temp_audio.aac';

      if (await requestMicrophonePermission()) {
        await _recorder.startRecorder(toFile: tempPath);
      } else {
        print("⚠️ Permission denied, cannot start recording.");
      }

      await Future.delayed(Duration(seconds: 10));
      await _recorder.stopRecorder();

      File audioFile = File(tempPath);
      if (await audioFile.exists()) {
        Uint8List audioBytes = await audioFile.readAsBytes();
        print("Recording completed. Audio size: ${audioBytes.length}");
        return audioBytes;
      } else {
        print("Recording failed: File not found.");
      }
    } catch (e) {
      print("Error during recording: $e");
    }
    return null;
  }

  Future<void> playAudio(Uint8List audioBytes) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/temp_audio.aac';
      File tempFile = File(tempPath);
      await tempFile.writeAsBytes(audioBytes);

      print("Playing audio from: $tempPath");
      await _audioPlayer.play(DeviceFileSource(tempPath));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }
}
