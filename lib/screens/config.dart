import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario_session.dart';
import '../services/audio_global_service.dart';
import 'iniciar_sesion.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  double volumen = 0.2; // 0.0 a 1.0
  bool muted = false;
  String tipoSeleccionado = "Seleccionar tipo...";
  TextEditingController nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarPreferencias();
  }

  Future<void> cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    volumen = prefs.getDouble("volumen") ?? 0.2;
    muted = prefs.getBool("mute") ?? false;

    nombreController.text = UsuarioSesion.nombreMascota ?? "";

    setState(() {});
  }

  Future<void> guardarVolumen(double v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("volumen", v);
    await prefs.setBool("mute", false);

    AudioGlobalService().setVolume(v);
  }

  Future<void> guardarMute(bool m) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("mute", m);

    m ? AudioGlobalService().mute() : AudioGlobalService().setVolume(volumen);
  }

  void cambiarNombreMascota() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cambiar nombre de mascota"),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(hintText: "Nuevo nombre"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              final nuevo = nombreController.text.trim();
              if (nuevo.isEmpty) return;

              await FirebaseFirestore.instance
                  .collection("usuario")
                  .doc(UsuarioSesion.email)
                  .update({"nombreMascota": nuevo});

              UsuarioSesion.nombreMascota = nuevo;

              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  
    UsuarioSesion.limpiar();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9DB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 18, color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Configuración",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🐾 NOMBRE MASCOTA — editable
                Row(
                  children: const [
                    Icon(Icons.pets, color: Colors.brown, size: 26),
                    SizedBox(width: 8),
                    Text("Nombre de mascota", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: cambiarNombreMascota,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Text(UsuarioSesion.nombreMascota ?? "Sin nombre"),
                  ),
                ),

                const SizedBox(height: 25),

                // 🔊 SONIDO — Slider + mute
                Row(
                  children: const [
                    Icon(Icons.volume_up, color: Colors.brown, size: 26),
                    SizedBox(width: 8),
                    Text("Sonido", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    IconButton(
                      icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                      color: Colors.orangeAccent,
                      iconSize: 30,
                      onPressed: () {
                        setState(() => muted = !muted);
                        guardarMute(muted);
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: volumen,
                        min: 0,
                        max: 1,
                        divisions: 100,
                        onChanged: (v) {
                          setState(() {
                            volumen = v;
                            muted = false;
                          });
                          guardarVolumen(v);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // 📧 CORREO
                Row(
                  children: const [
                    Icon(Icons.email_outlined, color: Colors.brown, size: 26),
                    SizedBox(width: 8),
                    Text("Correo", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Text(UsuarioSesion.email ?? "No disponible"),
                ),

                const SizedBox(height: 25),

                // 🏆 Nivel y monedas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.brown),
                        const SizedBox(width: 6),
                        const Text("Nivel: "),
                        Text("${UsuarioSesion.nivel ?? 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.brown),
                        const SizedBox(width: 6),
                        const Text("Monedas: "),
                        Text("${UsuarioSesion.monedas ?? 0}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // 🔄 CERRAR SESIÓN
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.brown,
                      side: const BorderSide(color: Colors.orangeAccent, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    ),
                    onPressed: cerrarSesion,
                    child: const Text("Cerrar sesión"),
                  ),
                ),

                const SizedBox(height: 25),

                // 🩷 ACEPTAR
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC8D0),
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

