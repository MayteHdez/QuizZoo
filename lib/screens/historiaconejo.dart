import 'package:flutter/material.dart';
import 'historiaconejo2.dart';
import '../services/history_music_service.dart';
import '../services/audio_global_service.dart';

class HistoriaConejo extends StatefulWidget {
  const HistoriaConejo({super.key});

  @override
  State<HistoriaConejo> createState() => _HistoriaConejoState();
}

class _HistoriaConejoState extends State<HistoriaConejo> {
  @override
  void initState() {
    super.initState();

    // Detener música de historia
    AudioGlobalService().stopGlobal();

    // Encender música global
    HistoryMusicService().playStoryMusic("musica/musicaconejo.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset('assets/conejo/CONEJOPARQUE.png', fit: BoxFit.cover),
          ),

          // Texto superior
          const Positioned(
            top: 80,
            left: 20,
            child: Text(
              "Caminando por el parque...\n"
              "Unos ladridos suenan cerca de ti...\n"
              "Asustado volteas y\n",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
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
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoriaConejo2()),
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