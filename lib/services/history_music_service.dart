import 'package:audioplayers/audioplayers.dart';

class HistoryMusicService {
  static final HistoryMusicService _instance = HistoryMusicService._internal();
  factory HistoryMusicService() => _instance;

  HistoryMusicService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playStoryMusic(String path) async {
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.3);
    await _player.play(AssetSource(path));
  }

  Future<void> stopStoryMusic() async {
    await _player.stop();
  }
}

