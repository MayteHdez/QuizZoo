import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'casa.dart';

class AlimentarScreen extends StatefulWidget {
  const AlimentarScreen({super.key});

  @override
  State<AlimentarScreen> createState() => _AlimentarScreenState();
}

class _AlimentarScreenState extends State<AlimentarScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> alimentosUser = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String _fondoActual = "assets/imagenes_general/castillo.png";
  int? alimentoDesapareciendoIndex;

  // Mapa de referencia para obtener imagen según el nombre del alimento
  final Map<String, String> imgMap = {
    "pollo": "assets/imagenes_general/pollo.png",
    "plato1": "assets/imagenes_general/plato1.png",
    "pescado": "assets/imagenes_general/pescado.png",
    "brocoli": "assets/imagenes_general/brocoli.png",
    "zanahoria": "assets/imagenes_general/zanahoria.png",
    "chicharo": "assets/imagenes_general/chicharo.png",
    "moras": "assets/imagenes_general/moras.png",
    "salmon": "assets/imagenes_general/salmon.png",
    "plato2": "assets/imagenes_general/plato2.png",
    "lata": "assets/imagenes_general/lata.png",
    "hoja": "assets/imagenes_general/hoja.png",
    "melon": "assets/imagenes_general/melon.png",
  };

  @override
  void initState() {
    super.initState();
    _cargarFondo();
    setupAnimacion();
    cargarAlimentos();
  }

  void _cargarFondo() async {
    final prefs = await SharedPreferences.getInstance();
    String? fondo = prefs.getString("fondoSeleccionado");
    setState(() {
      _fondoActual = fondo ?? "assets/imagenes_general/castillo.png";
    });
  }

  void setupAnimacion() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  Future<void> cargarAlimentos() async {
    final doc =
        await FirebaseFirestore.instance
            .collection("usuario")
            .doc(UsuarioSesion.email)
            .get();
    Map<String, dynamic> alimentosDB = doc.data()?["alimentos"] ?? {};

    setState(() {
      alimentosUser =
          alimentosDB.entries.map((e) {
            return {
              "id": e.key,
              "img": imgMap[e.key] ?? "assets/imagenes_general/unknown.png",
              "cantidad": e.value,
            };
          }).toList();
    });
  }

  Future<void> mascotaComio(int index) async {
    alimentoDesapareciendoIndex = index;

    // Animación desaparecer
    await _fadeController.forward();

    // ⚠ Pequeña pausa para evitar error cuando se elimina un item
    await Future.delayed(const Duration(milliseconds: 100));

    final alimento = alimentosUser[index];

    // Restar 1 unidad
    alimento["cantidad"] -= 1;

    // Si se agotó, eliminarlo
    if (alimento["cantidad"] <= 0) {
      alimentosUser.removeAt(index);
    }

    setState(() {});

    // Actualizar Firestore
    Map<String, int> dbUpdate = {};
    for (var a in alimentosUser) {
      dbUpdate[a["id"]] = a["cantidad"];
    }

    await FirebaseFirestore.instance
        .collection("usuario")
        .doc(UsuarioSesion.email)
        .update({
          "alimentos": dbUpdate,
          "ultima_comida": DateTime.now().millisecondsSinceEpoch,
        });

    // Reset animación
    _fadeController.reset();
    alimentoDesapareciendoIndex = null;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String mascota = "assets/gato/gato.png";
    switch (UsuarioSesion.tipoMascota) {
      case "perro":
        mascota = "assets/perro/perro.png";
        break;
      case "conejo":
        mascota = "assets/conejo/conejo.png";
        break;
    }
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _fondoActual,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CasaScreen()),
                  ),
              child: const Icon(
                Icons.arrow_back,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DragTarget<String>(
                onAccept: (idAlimento) {
                  final index = alimentosUser.indexWhere(
                    (a) => a["id"] == idAlimento,
                  );
                  mascotaComio(index);
                },

                builder: (context, candidate, rejected) {
                  return Center(child: Image.asset(mascota, height: 250));
                },
              ),
              const SizedBox(height: 30),
              Container(
                height: 130,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2CD64), // Amarillo cálido
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Flecha izquierda
                    GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          _scrollController.offset - 120,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            183,
                            143,
                            205,
                          ), // morado suave bonito
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Carrusel de comida
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: alimentosUser.length,
                        itemBuilder: (context, index) {
                          final alimento = alimentosUser[index];
                          final animando = alimentoDesapareciendoIndex == index;

                          Widget comidaWidget = Opacity(
                            opacity: animando ? _fadeAnimation.value : 1,
                            child: Transform.scale(
                              scale: animando ? _scaleAnimation.value : 1,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Image.asset(alimento["img"], width: 90),
                                  if (alimento["cantidad"] > 1)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${alimento["cantidad"]}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Draggable<String>(
                              data: alimento["id"],
                              feedback: Image.asset(alimento["img"], width: 90),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: comidaWidget,
                              ),
                              child: comidaWidget,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Flecha derecha
                    GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          _scrollController.offset + 120,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            183,
                            143,
                            205,
                          ), // morado suave bonito
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
