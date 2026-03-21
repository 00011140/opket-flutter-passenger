import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(String assetPath) async {
    print("🔊🔊🔊🔊 $assetPath");
    await _audioPlayer.play(AssetSource(assetPath));
    await _audioPlayer.onPlayerComplete.first;
  }

  Future<void> playLoop(String assetPath) async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(assetPath));
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  Future<void> pauseSound() async {
    await _audioPlayer.pause();
  }

  // You can add volume control, looping, etc.
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }
}
