import 'package:flutter/material.dart';
import '../widgets/globo_dialogo.dart';
import 'mapa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../usuario_session.dart';

class HistoriaPerro5 extends StatefulWidget {
  const HistoriaPerro5({super.key});

  @override
  State<HistoriaPerro5> createState() => _HistoriaPerro5State();
}

class _HistoriaPerro5State extends State<HistoriaPerro5> {
  final TextEditingController _nombreController = TextEditingController();
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset('assets/perro/finalfeliz.png', fit: BoxFit.cover),
          ),

          // Globo
          const Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: GloboDialogo(texto: "¡Ahora dale un nombre a tu perrito!"),
          ),

          // Imagen del perro
          Positioned(
            top: 210,
            left: 0,
            right: 0,
            child: Image.asset('assets/perro/perro.png', height: 270),
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
                errorText: _guardando && _nombreController.text.trim().isEmpty
                    ? "Debes escribir un nombre"
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Botón guardar
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
                onPressed: _guardando
                    ? null
                    : () async {
                        String nombre = _nombreController.text.trim();

                        setState(() => _guardando = true);

                        if (nombre.isEmpty) {
                          setState(() => _guardando = false);
                          return; // activa la validación visual
                        }

                        try {
                          UsuarioSesion.nombreMascota = nombre;

                          // GUARDAR (CORREGIDO)
                          await FirebaseFirestore.instance
                              .collection("usuario")
                              .doc(UsuarioSesion.email)
                              .set(
                            {"nombre_m": nombre},
                            SetOptions(merge: true),
                          );

                          // Mensaje
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Tu perrito se llama $nombre"),
                            ),
                          );

                          // Navegar
                          await Future.delayed(const Duration(seconds: 1));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapaScreen(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Error al guardar nombre: $e")),
                          );
                        }

                        setState(() => _guardando = false);
                      },
                child: _guardando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Guardar", style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}