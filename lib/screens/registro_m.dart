import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'historiagato.dart';
import 'historiaconejo.dart';
import 'historiaperro.dart';
import '../usuario_session.dart';



class RegistroMascotaScreen extends StatefulWidget {
  final String email;

  const RegistroMascotaScreen({super.key, required this.email});

  @override
  State<RegistroMascotaScreen> createState() => _RegistroMascotaScreenState();
}

class _RegistroMascotaScreenState extends State<RegistroMascotaScreen> {
  String? mascotaSeleccionada;

  Future<void> _guardarMascota(String tipo) async {
    setState(() => mascotaSeleccionada = tipo);
    UsuarioSesion.tipoMascota = tipo;

    try {
      await FirebaseFirestore.instance
          .collection("usuario")
          .doc(widget.email)
          .update({"tipo_m": tipo});
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
                  Text(
                    "Elige tu mascota",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              mascotaButton("gato", "assets/gato/gato.png"),
              const SizedBox(height: 20),

              mascotaButton("perro", "assets/perro/perro.png"),
              const SizedBox(height: 20),

              mascotaButton("conejo", "assets/conejo/conejo.png"),
              const SizedBox(height: 40),

              if (mascotaSeleccionada != null)
                ElevatedButton(
                  onPressed: () {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Mascota ${mascotaSeleccionada!} registrada correctamente")),
  );

  // Si eligió gato → ir a la historia del gato
  if (mascotaSeleccionada == "gato") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoriaGato()),
    );
  }

  // Luego puedes agregar más pantallas si deseas:
  else if (mascotaSeleccionada == "perro") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoriaPerro()),
    );
  }

  else if (mascotaSeleccionada == "conejo") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoriaConejo()),
    );
  }
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Continuar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mascotaButton(String tipo, String path) {
    bool seleccionado = mascotaSeleccionada == tipo;
    return GestureDetector(
      onTap: () => _guardarMascota(tipo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: seleccionado ? Colors.white.withOpacity(0.6) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: seleccionado
              ? Border.all(color: Colors.orangeAccent, width: 3)
              : null,
        ),
        child: Image.asset(path, height: 100),
      ),
    );
  }
}
