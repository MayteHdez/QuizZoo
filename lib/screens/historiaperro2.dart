import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'historiaperro3.dart';

class HistoriaPerro2 extends StatefulWidget {
  const HistoriaPerro2({super.key});

  @override
  State<HistoriaPerro2> createState() => _HistoriaPerro2State();
}

class _HistoriaPerro2State extends State<HistoriaPerro2> {
  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _activarEfectos();
  }

  Future<void> _activarEfectos() async {

  // Reproducir 
  await _player1.play(AssetSource('perro/bolsa.mp3'));
  await Future.delayed(const Duration(milliseconds: 800));

  // Reproducir 
  await _player2.play(AssetSource('perro/llorando.mp3'));

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
              'assets/perro/BASURERO.png',
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
                    MaterialPageRoute(builder: (_) => const HistoriaPerro3()),
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