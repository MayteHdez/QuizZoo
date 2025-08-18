import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroMascotaScreen extends StatelessWidget {
  final String email; //

  const RegistroMascotaScreen({super.key, required this.email});

  Future<void> _guardarMascota(BuildContext context, String tipo) async {
    try {
      await FirebaseFirestore.instance.collection("usuario").doc(email).update({
        "tipo_m": tipo,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mascota $tipo seleccionada")),
      );

      // Aquí podrías navegar a la pantalla principal de la app
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar mascota: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4DDE1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Registro",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 18),
                  SizedBox(width: 6),
                  Text("Elige tu mascota",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 30),

              // Botón Gato
              GestureDetector(
                onTap: () => _guardarMascota(context, "gato"),
                child: Image.asset("assets/gato/gato.png",
                    height: 100),
              ),
              const SizedBox(height: 20),

              // Botón Perro
              GestureDetector(
                onTap: () => _guardarMascota(context, "perro"),
                child: Image.asset("assets/perro/perro.png",
                    height: 100),
              ),
              const SizedBox(height: 20),

              // Botón Conejo
              GestureDetector(
                onTap: () => _guardarMascota(context, "conejo"),
                child: Image.asset("assets/conejo/conejo.png",
                    height: 100),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // volver atrás si no quiere elegir
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Continuar",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
