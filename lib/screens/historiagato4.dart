import 'package:flutter/material.dart';
import '../widgets/globo_dialogo.dart';
import 'historiagato5.dart';

class HistoriaGato4 extends StatelessWidget {
  const HistoriaGato4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/gato/GATOCALLE.png',
              fit: BoxFit.cover,
            ),
          ),

          const Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: GloboDialogo(
              texto: "¡Has decidido adoptarlo para darle una mejor vida!",
            ),
          ),

          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/gato/gato_feliz.png',
              height: 260,
            ),
          ),

          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoriaGato5()),
                  );
                },
                child: const Text(
                  "Continuar",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}