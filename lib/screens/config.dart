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
            style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
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
        style: const TextStyle(color: Colors.black),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Configuración",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 🐾 Nombre tu mascota (solo texto)
              Row(
                children: const [
                  Icon(Icons.pets, color: Colors.brown),
                  SizedBox(width: 8),
                  Text(
                    "Nombre tu mascota",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Nombre ejemplo",
                  style: TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 20),

              // ❓ Tipos de preguntas (abre tabla)
              Row(
                children: const [
                  Icon(Icons.help_outline, color: Colors.brown),
                  SizedBox(width: 8),
                  Text(
                    "Tipos de preguntas",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _mostrarOpcionesTipo,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tipoSeleccionado,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔊 Sonido con + y -
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.volume_up, color: Colors.brown),
                      SizedBox(width: 8),
                      Text(
                        "Sonido",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 22),
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 22),
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

              const SizedBox(height: 15),

              // 📧 Correo
              Row(
                children: const [
                  Icon(Icons.email_outlined, color: Colors.brown),
                  SizedBox(width: 8),
                  Text(
                    "Correo",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "ejemplo@gmail.com",
                  style: TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 20),

              // 🏆 Nivel y Monedas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.emoji_events, color: Colors.brown),
                      SizedBox(width: 8),
                      Text(
                        "Nivel",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "4",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.attach_money, color: Colors.brown),
                      SizedBox(width: 8),
                      Text(
                        "Monedas",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "127",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🔄 Cambiar cuenta
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    side: const BorderSide(color: Colors.orangeAccent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {},
                  child: const Text("Cambiar cuenta"),
                ),
              ),

              const SizedBox(height: 15),

              // 🩷 Aceptar
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC8D0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
    );
  }
}
