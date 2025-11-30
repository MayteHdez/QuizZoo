import 'package:flutter/material.dart';

class IncorrectaScreen extends StatefulWidget {
  const IncorrectaScreen({super.key});

  @override
  State<IncorrectaScreen> createState() => _IncorrectaScreenState();
}

class _IncorrectaScreenState extends State<IncorrectaScreen> {
  @override
  void initState() {
    super.initState();

    // Espera 2 segundos y luego regresa a la pantalla anterior
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // vuelve a PreguntaScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(219, 247, 130, 148), 
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ⭐ ENCABEZADO
            Row(
              children: [
                Image.asset("assets/imagenes_general/reloj.png", height: 35),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 📘 TARJETA
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // 🔵 ÍTEM 1
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 107, 156),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bar_chart, color: Colors.white, size: 26),
                        const SizedBox(width: 10),
                        const Text(
                          "Nivel",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          "assets/imagenes_general/igual.png",
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔵 ÍTEM 2
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 107, 156),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.attach_money, color: Colors.white, size: 26),
                        const SizedBox(width: 10),
                        const Text(
                          "Monedas",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          "assets/imagenes_general/igual.png",
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: const Alignment(0.5, 0), 
              child: Image.asset(
                "assets/imagenes_general/mal.png",
                height: 200,
              ),
            ),

            Align(
              alignment: const Alignment(-0.5, 0), 
              child: Image.asset(
                "assets/gato/gato_triste.png",
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
