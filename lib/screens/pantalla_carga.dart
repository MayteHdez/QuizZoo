import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final List<String> messages = [
    "En los niveles  1 y 2 NO se maneja limite de tiempo \nJuega con tranquilidad",
    "En los niveles 3 y 4 SI se maneja limite de tiempo",
    "Cuando completes los 4 niveles de un tema recibirás un regalo especial",
    "Una respuesta correcta en \n🐾Nivel 1 =2 monedas \n🐾Nivel 2 = 5 monedas \n🐾Nivel 3 = 7 monedas \n🐾Nivel 4 = 10 monedas"
  ];

  int currentMessageIndex = 0;
  late Timer timer;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Cambiar mensaje cada 5 segundos
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      setState(() {
        currentMessageIndex =
            (currentMessageIndex + 1) % messages.length; // ciclo
      });
    });

    // Animación scroll infinito
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // velocidad del scroll
    )..repeat(); // se reinicia infinito
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE5B4),
      body: SafeArea(
        child: Column(
          children: [
            // Logo arriba
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/imagenes_general/logo_quizzoo.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),

            // Animalitos caminando (scroll infinito)
            Expanded(
              flex: 3,
              child: ClipRect(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double dx = _controller.value * 800; // mueve 200px
                    return Stack(
                      children: [
                        Positioned(
                          left: dx,
                          top: 0,
                          bottom: 0,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/imagenes_general/animales_caminando.png',
                                fit: BoxFit.contain,
                                height: 150, // ajusta según el alto deseado
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),


            // Cuadro de mensajes
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: screenWidth * 0.6, // menos ancho
                height: screenHeight * 0.25, // más alto
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 249, 187, 220),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    messages[currentMessageIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
