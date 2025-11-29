import 'package:flutter/material.dart';
import 'correcta.dart';
import 'incorrecta.dart';

class PreguntaScreen extends StatelessWidget {
  const PreguntaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffc9e6df), // fondo verde pastel
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ⭐ ENCABEZADO
            Row(
              children: [
                Image.asset(
                  "assets/imagenes_general/reloj.png",
                  height: 35,
                ),
                const SizedBox(width: 15),

                // Barra rosa
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

            // 📘 TARJETA DE PREGUNTA
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "¿En qué país se originaron los\nJuegos Olímpicos?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🟡 BOTONES DE RESPUESTA
            respuesta("A) Italia", () { 
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IncorrectaScreen()),
                              );
            }),
            const SizedBox(height: 12),

            respuesta("B) Francia", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IncorrectaScreen()),
                              );
            }),
            const SizedBox(height: 12),

            respuesta("C) México", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IncorrectaScreen()),
                              );
            }),
            const SizedBox(height: 12),

            respuesta("D) Grecia", () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CorrectaScreen()),
                              );
            }),

            const Spacer(),

            // 🐱 GATITO ABAJO
            Image.asset(
              "assets/gato/gato.png",
              height: 120,
            ),
          ],
        ),
      ),
    );
  }

  // FUNCION PARA REUSAR BOTONES
Widget respuesta(String texto, VoidCallback onTap) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

}
