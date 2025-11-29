import 'package:flutter/material.dart';

class FondoScreen extends StatelessWidget {
  const FondoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      body: Column(
        children: [
          // Encabezado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFFFC8D0),
            child: const Center(
              child: Text(
                "Seleccionar fondo (Sigue jugando para obtenerlos todos)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Grid ajustado para rectángulos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,

                // 📌 Rectangulares — más altas que anchas
                childAspectRatio: 0.58, // AJUSTADO PARA RECTÁNGULOS

                children: [
                  _botonFondo("assets/imagenes_general/castillo.png"),
                  _botonFondo("assets/imagenes_general/playabn.png"),
                  _botonFondo("assets/imagenes_general/feriabn.png"),
                  _botonFondo("assets/imagenes_general/storebn.png"),
                  _botonFondo("assets/imagenes_general/libreriabn.png"),
                  _botonFondo("assets/imagenes_general/trenbn.png"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonFondo(String ruta) {
    return GestureDetector(
      onTap: () {
        print("Seleccionaste: $ruta");
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          ruta,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

