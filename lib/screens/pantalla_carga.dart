import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/imagenes_general/caminando.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true); // 🔁 para que el video camine sin parar
        _controller.play(); // ▶️ empieza automáticamente
        setState(() {}); // refresca la pantalla cuando el video está listo
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECC9),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imagenes_general/logo.png', width: 250),
              const SizedBox(height: 30),

              // 🐾 Aquí el video
              _controller.value.isInitialized
                  ? SizedBox(
                      width: 200,
                      height: 120,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),

              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBABA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Hasta que no hayas amado a un animal,\n'
                  'una parte de tu alma permanecerá dormida.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
