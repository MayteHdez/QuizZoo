import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'correcta.dart';
import 'incorrecta.dart';

class PreguntaScreen extends StatefulWidget {
  final int nivel;
  final String tema;
  final List<String> preguntasUsadas; // IDs ya usadas

  const PreguntaScreen({
    super.key,
    required this.nivel,
    required this.tema,
    required this.preguntasUsadas,
  });

  @override
  State<PreguntaScreen> createState() => _PreguntaScreenState();
}

class _PreguntaScreenState extends State<PreguntaScreen> {
  Map<String, dynamic>? pregunta; // aquí guardamos la pregunta cargada
  String docId = "";
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarPregunta();
  }

  Future<void> cargarPregunta() async {
    setState(() => cargando = true);

    try {
      final consulta = await FirebaseFirestore.instance
          .collection("preguntas")
          .where("nivel", isEqualTo: widget.nivel)
          .where("tema", isEqualTo: widget.tema)
          .get();

      // Filtrar preguntas que ya salieron
      final disponibles = consulta.docs
          .where((d) => !widget.preguntasUsadas.contains(d.id))
          .toList();

      if (disponibles.isEmpty) {
        // Ya no hay preguntas → regresar
        if (mounted) Navigator.pop(context);
        return;
      }

      // Escoger una al azar
      disponibles.shuffle();
      final seleccion = disponibles.first;

      pregunta = seleccion.data();
      docId = seleccion.id;

      setState(() => cargando = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error cargando pregunta: $e")),
        );
      }
      setState(() => cargando = false);
    }
  }

  void responder(bool correcta) {
    // Guardar que ya usamos esta pregunta
    widget.preguntasUsadas.add(docId);

    // Navegar según respuesta
    final pantalla = correcta ? const CorrectaScreen() : const IncorrectaScreen();

    Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla))
        .then((_) => cargarPregunta()); // recargar pregunta al volver
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        backgroundColor: Color(0xffc9e6df),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Armar lista de respuestas mezclada con seguridad ante null
    final respuestas = [
      {"texto": pregunta?["rc"] ?? "", "correcta": true},
      {"texto": pregunta?["ri1"] ?? "", "correcta": false},
      {"texto": pregunta?["ri2"] ?? "", "correcta": false},
      {"texto": pregunta?["ri3"] ?? "", "correcta": false},
    ];
    respuestas.shuffle();

    return Scaffold(
      backgroundColor: const Color(0xffc9e6df),
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

            // 📘 TARJETA DE PREGUNTA
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  pregunta?["pregunta"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🟡 RESPUESTAS DINÁMICAS
            ...respuestas.map((r) => Column(
                  children: [
                    respuesta(r["texto"], () => responder(r["correcta"])),
                    const SizedBox(height: 12),
                  ],
                )).toList(),

            const Spacer(),

            // 🐱 GATITO
            Image.asset("assets/gato/gato.png", height: 120),
          ],
        ),
      ),
    );
  }

  // COMPONENTE BOTÓN
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
