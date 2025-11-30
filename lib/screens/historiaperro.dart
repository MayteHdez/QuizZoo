import 'package:flutter/material.dart';
import 'historiaperro2.dart';
import '../services/history_music_service.dart';
import '../services/audio_global_service.dart';

class HistoriaPerro extends StatefulWidget {
  const HistoriaPerro({super.key});

  @override
  State<HistoriaPerro> createState() => _HistoriaPerroState();
}

class _HistoriaPerroState extends State<HistoriaPerro> {
  @override
  void initState() {
    super.initState();

    // Detener música de historia
    AudioGlobalService().stopGlobal();

    // Encender música global
    HistoryMusicService().playStoryMusic("musica/musicaperro.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset('assets/perro/BASURERO.png', fit: BoxFit.cover),
          ),

          // Texto superior
          const Positioned(
            top: 80,
            left: 20,
            child: Text(
              "Estas pasando por una calle...\n"
              "silenciosa y escuchas un sonido\n"
              "cerca de ti, y asutado volteas\n",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
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
                    MaterialPageRoute(builder: (_) => const HistoriaPerro2()),
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
