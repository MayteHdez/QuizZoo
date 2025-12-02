import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario_session.dart';

class FondoScreen extends StatefulWidget {
  const FondoScreen({super.key});

  @override
  State<FondoScreen> createState() => _FondoScreenState();
}

class _FondoScreenState extends State<FondoScreen> {
  @override
  void initState() {
    super.initState();

  }

  Future<void> _guardarFondo(String ruta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fondoSeleccionado', ruta);
  }

  @override
  Widget build(BuildContext context) {
    // Lista de fondos con niveles requeridos y versiones color/BN
    final List<Map<String, dynamic>> fondos = [
      {
        "rutaColor": "assets/imagenes_general/castillo.png",
        "rutaBN": "assets/imagenes_general/castillo.png",
        "nivel": 0
      },
      {
        "rutaColor": "assets/imagenes_general/playa.png",
        "rutaBN": "assets/imagenes_general/playabn.png",
        "nivel": 10
      },
      {
        "rutaColor": "assets/imagenes_general/feria.png",
        "rutaBN": "assets/imagenes_general/feriabn.png",
        "nivel": 20
      },
      {
        "rutaColor": "assets/imagenes_general/store.png",
        "rutaBN": "assets/imagenes_general/storebn.png",
        "nivel": 30
      },
      {
        "rutaColor": "assets/imagenes_general/libreria.png",
        "rutaBN": "assets/imagenes_general/libreriabn.png",
        "nivel": 40
      },
      {
        "rutaColor": "assets/imagenes_general/trenf.png",
        "rutaBN": "assets/imagenes_general/trenbn.png",
        "nivel": 50
      },
    ];

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
                "Seleccionar fondo (Sigue jugando para obtenerlos)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: fondos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  final fondo = fondos[index];
                  final int nivelActual = UsuarioSesion.nivel ?? 0;
                  final bool desbloqueado = nivelActual >= fondo["nivel"];
                  return _botonFondo(fondo, desbloqueado, fondo["nivel"]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonFondo(Map<String, dynamic> fondo, bool desbloqueado, int nivelNecesario) {
    final ruta = desbloqueado ? fondo["rutaColor"] : fondo["rutaBN"];

    return GestureDetector(
      onTap: () async {
        if (!desbloqueado) {
          // ❌ Fondo bloqueado → Mostrar mensaje
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("✋ Necesitas nivel $nivelNecesario para desbloquear este fondo."),
            ),
          );
          return;
        }

        // ✔ Guardar selección (versión a color)
        await _guardarFondo(fondo["rutaColor"]);

        // ✔ Regresar a CasaScreen
        Navigator.pop(context, fondo["rutaColor"]); // Enviar la ruta seleccionada
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              ruta,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // ❌ Candado si está bloqueado
          if (!desbloqueado)
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

          // Texto del nivel necesario
          if (!desbloqueado)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Text(
                "Nivel $nivelNecesario",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Color.fromARGB(150, 0, 0, 0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
