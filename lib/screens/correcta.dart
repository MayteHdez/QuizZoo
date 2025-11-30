import 'package:flutter/material.dart';
import '../usuario_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CorrectaScreen extends StatefulWidget {
  final int monedasGanadas;

  const CorrectaScreen({super.key, required this.monedasGanadas});

  @override
  State<CorrectaScreen> createState() => _CorrectaScreenState();
}


class _CorrectaScreenState extends State<CorrectaScreen> {

   /// FUNCION PARA CALCULAR NIVEL
  int calcularNivel(int puntos) {
    int nivel = (puntos ~/ 15) + 1;  // Cada 15 puntos = +1 nivel
    if (nivel > 50) nivel = 50;      // Máximo nivel 50
    return nivel;
  }


  @override
    void initState() {
      super.initState();

          // 1️⃣ SUMAR MONEDAS
        UsuarioSesion.monedas =
            (UsuarioSesion.monedas ?? 0) + widget.monedasGanadas;

        // 2️⃣ SUMAR PUNTOS (esto es lo que te sube el nivel)
        UsuarioSesion.puntos =
            (UsuarioSesion.puntos ?? 0) + widget.monedasGanadas;

        // 3️⃣ CALCULAR NIVEL SEGÚN PUNTOS
        UsuarioSesion.nivel = calcularNivel(UsuarioSesion.puntos!);

        // 4️⃣ GUARDAR EN FIRESTORE
        FirebaseFirestore.instance
            .collection("usuario")
            .doc(UsuarioSesion.email)
            .update({
          "monedas": UsuarioSesion.monedas,
          "puntos": UsuarioSesion.puntos,
          "nivel": UsuarioSesion.nivel,
        });
      // Espera 2 segundos y luego regresa
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // vuelve a PreguntaScreen
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9F8C4), // fondo verde pastel
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
                  // 🔵 ÍTEM 1 — MÁS GRANDE
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
                          "assets/imagenes_general/flecha.png",
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔵 ÍTEM 2 — MÁS GRANDE
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
                          "assets/imagenes_general/flecha.png",
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🎉 IMAGEN "bien"
            Align(
              alignment: const Alignment(0.5, 0),
              child: Image.asset(
                "assets/imagenes_general/bien.png",
                height: 200,
              ),
            ),

            // 🐱 GATO FELIZ
            Align(
              alignment: const Alignment(-0.5, 0),
              child: Image.asset(
                "assets/gato/gato_feliz.png",
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
