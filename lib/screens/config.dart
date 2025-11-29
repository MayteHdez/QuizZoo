import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  int volumen = 100;
  String tipoSeleccionado = "Seleccionar tipo...";

  void _mostrarOpcionesTipo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFF9DB),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Selecciona tipo de preguntas",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _opcionTipo("Ambos"),
              const Divider(),
              _opcionTipo("Solo audio"),
              const Divider(),
              _opcionTipo("Solo imagen"),
            ],
          ),
        );
      },
    );
  }

  Widget _opcionTipo(String texto) {
    return ListTile(
      title: Text(
        texto,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: tipoSeleccionado == texto
          ? const Icon(Icons.check, color: Colors.orangeAccent)
          : null,
      onTap: () {
        setState(() {
          tipoSeleccionado = texto;
        });
        Navigator.pop(context);
      },
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

                // 🐾 Nombre tu mascota
                Row(
                  children: const [
                    Icon(Icons.pets, color: Colors.brown, size: 26),
                    SizedBox(width: 8),
                    Text("Nombre tu mascota",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Nombre ejemplo"),
                ),

                const SizedBox(height: 25),

                // ❓ Tipos de preguntas
                Row(
                  children: const [
                    Icon(Icons.help_outline, color: Colors.brown, size: 26),
                    SizedBox(width: 8),
                    Text("Tipos de preguntas",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _mostrarOpcionesTipo,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(tipoSeleccionado),
                  ),
                ),

                const SizedBox(height: 25),

                // 🔊 Sonido
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.volume_up, color: Colors.brown, size: 26),
                        SizedBox(width: 8),
                        Text("Sonido",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.remove_circle_outline, size: 28),
                          color: Colors.orangeAccent,
                          onPressed: () {
                            setState(() {
                              if (volumen > 0) volumen -= 1;
                            });
                          },
                        ),
                        Text(
                          "$volumen%",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 28),
                          color: Colors.orangeAccent,
                          onPressed: () {
                            setState(() {
                              if (volumen < 100) volumen += 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 📧 Correo
                Row(
                  children: const [
                    Icon(Icons.email_outlined, color: Colors.brown, size: 26),
                    SizedBox(width: 8),
                    Text("Correo",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("ejemplo@gmail.com"),
                ),

                const SizedBox(height: 25),

                // 🏆 Nivel y Monedas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.brown, size: 26),
                        const SizedBox(width: 8),
                        const Text("Nivel",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "4",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            color: Colors.brown, size: 26),
                        const SizedBox(width: 8),
                        const Text("Monedas",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "127",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // 🔄 Cambiar cuenta
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.brown,
                      side: const BorderSide(color: Colors.orangeAccent, width: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {},
                    child: const Text("Cambiar cuenta"),
                  ),
                ),

                const SizedBox(height: 20),

                // 🩷 Aceptar
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC8D0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white),
                    ),
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
