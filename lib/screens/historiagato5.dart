import 'package:flutter/material.dart';
import '../widgets/globo_dialogo.dart';
import 'mapa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../usuario_session.dart';


class HistoriaGato5 extends StatefulWidget {
  const HistoriaGato5({super.key});

  @override
  State<HistoriaGato5> createState() => _HistoriaGato5State();
}

class _HistoriaGato5State extends State<HistoriaGato5> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset('assets/gato/finalfeliz.png', fit: BoxFit.cover),
          ),

          // Globo de diálogo
          const Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: GloboDialogo(texto: "¡Ahora dale un nombre a tu gatito!"),
          ),

          // Imagen del gato
          Positioned(
            top: 210,
            left: 0,
            right: 0,
            child: Image.asset('assets/gato/gato_feliz.png', height: 270),
          ),

          // Campo de texto
          Positioned(
            bottom: 160,
            left: 30,
            right: 30,
            child: TextField(
              controller: _nombreController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Escribe el nombre aquí",
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Botón Guardar
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final nombre = _nombreController.text.trim();

                  if (nombre.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Escribe un nombre")),
                    );
                    return;
                  }

                  // Guardar en memoria
                  UsuarioSesion.nombreMascota = nombre;

                  try {
                    // Guardar en Firestore
                    await FirebaseFirestore.instance
                        .collection("usuario")
                        .doc(UsuarioSesion.email)
                        .update({"nombre_m": nombre});

                    // Mostrar mensaje
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tu gatito se llama $nombre")),
                    );

                    // Esperar y navegar
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapaScreen(),
                        ),
                      );
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al guardar el nombre: $e")),
                    );
                  }
                },

                child: const Text("Guardar", style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
