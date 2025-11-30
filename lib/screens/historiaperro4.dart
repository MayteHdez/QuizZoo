import 'package:flutter/material.dart';
import '../widgets/globo_dialogo.dart';
import 'historiaperro5.dart';

class HistoriaPerro4 extends StatelessWidget {
  const HistoriaPerro4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/perro/BASURERO.png',
              fit: BoxFit.cover,
            ),
          ),

          const Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: GloboDialogo(
              texto: "¡Has decidido quedartelo y darle un hogar!",
            ),
          ),

          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/perro/perro.png',
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
                    MaterialPageRoute(builder: (_) => const HistoriaPerro5()),
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