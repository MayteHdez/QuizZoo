import 'package:audioplayers/audioplayers.dart';

class AudioGlobalService {
  static final AudioGlobalService _instance = AudioGlobalService._internal();
  factory AudioGlobalService() => _instance;

  AudioGlobalService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.2; // volumen inicial

  /// Inicia la música si no está sonando
  Future<void> playGlobalMusic(String audioName) async {
    if (_isPlaying) return; // evita reinicios

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(_volume);

    await _player.play(AssetSource(audioName));
    _isPlaying = true;
  }

  /// Pausar música
  Future<void> pauseGlobal() async {
    await _player.pause();
    _isPlaying = false;
  }

  /// Detener completa (solo para cerrar sesión)
  Future<void> stopGlobal() async {
    await _player.stop();
    _isPlaying = false;
  }

  /// Ajustar volumen
  void setVolume(double nuevo) {
    _volume = nuevo;
    _player.setVolume(_volume);
  }

  /// Saber si está sonando
  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  void mute() {
    _volume = 0;
    _player.setVolume(0);
  }

  void unmute(double vol) {
    _volume = vol;
    _player.setVolume(vol);
  }
}

