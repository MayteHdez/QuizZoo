import 'package:audioplayers/audioplayers.dart';

class AudioGlobalService {
  static final AudioGlobalService _instance = AudioGlobalService._internal();
  factory AudioGlobalService() => _instance;

  AudioGlobalService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playGlobalMusic(String audioName) async {
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.2);
    await _player.play(AssetSource(audioName));
  }

  Future<void> stopGlobal() async {
    await _player.stop();
  }
}