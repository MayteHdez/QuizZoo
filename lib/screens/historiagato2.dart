import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'historiagato3.dart';

class HistoriaGato2 extends StatefulWidget {
  const HistoriaGato2({super.key});

  @override
  State<HistoriaGato2> createState() => _HistoriaGato2State();
}

class _HistoriaGato2State extends State<HistoriaGato2> {
  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _activarEfectos();
  }

  Future<void> _activarEfectos() async {

  // Reproducir coche
  await _player1.play(AssetSource('gato/coche.mp3'));
  await Future.delayed(const Duration(milliseconds: 800));

  // Reproducir gato
  await _player2.play(AssetSource('gato/gato.mp3'));

  // Cuando termine gato.mp3 → vibrar
  _player2.onPlayerComplete.listen((event) {
    _vibrarFuerte();
  });
}

  Future<void> _vibrarFuerte() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500); // 0.5 segundos
    }
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/gato/GATOCALLE.png',
              fit: BoxFit.cover,
            ),
          ),
          // Botón Continuar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoriaGato3()),
                  );
                },
                child: const Text("Continuar"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
