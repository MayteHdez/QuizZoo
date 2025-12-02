import 'package:flutter/material.dart';
import '../usuario_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mapa.dart';

class IngredientesScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onCompra; // callback a AlimentarScreen

  const IngredientesScreen({super.key, this.onCompra});

  @override
  State<IngredientesScreen> createState() => _IngredientesScreenState();
}

class _IngredientesScreenState extends State<IngredientesScreen>
    with SingleTickerProviderStateMixin {
  // ANIMACIÓN DE COMPRA
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _showAnim = false;
  String _animImg = "";

  final ingredientes = [
    {"key": "pollo", "img": "assets/imagenes_general/pollo.png", "precio": 25},
    {
      "key": "plato1",
      "img": "assets/imagenes_general/plato1.png",
      "precio": 10,
    },
    {
      "key": "pescado",
      "img": "assets/imagenes_general/pescado.png",
      "precio": 25,
    },
    {
      "key": "brocoli",
      "img": "assets/imagenes_general/brocoli.png",
      "precio": 15,
    },
    {
      "key": "zanahoria",
      "img": "assets/imagenes_general/zanahoria.png",
      "precio": 15,
    },
    {
      "key": "chicharo",
      "img": "assets/imagenes_general/chicharo.png",
      "precio": 10,
    },
    {"key": "moras", "img": "assets/imagenes_general/moras.png", "precio": 10},
    {
      "key": "salmon",
      "img": "assets/imagenes_general/salmon.png",
      "precio": 25,
    },
    {
      "key": "plato2",
      "img": "assets/imagenes_general/plato2.png",
      "precio": 10,
    },
    {"key": "lata", "img": "assets/imagenes_general/lata.png", "precio": 30},
    {"key": "hoja", "img": "assets/imagenes_general/hoja.png", "precio": 10},
    {"key": "melon", "img": "assets/imagenes_general/melon.png", "precio": 10},
  ];

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

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = Tween<double>(begin: 2.0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _fadeAnim = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showAnim = false);
        _animController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _guardarCompra(String itemKey) async {
    final userDoc = FirebaseFirestore.instance
        .collection("usuario")
        .doc(UsuarioSesion.email);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      Map<String, dynamic> alimentos = {};
      if (snapshot.data()!.containsKey("alimentos")) {
        alimentos = Map<String, dynamic>.from(snapshot["alimentos"]);
      }
      alimentos[itemKey] = (alimentos[itemKey] ?? 0) + 1;
      transaction.update(userDoc, {"alimentos": alimentos});

      // enviar callback a AlimentarScreen
      if (widget.onCompra != null) {
        widget.onCompra!({
          "id": itemKey,
          "img": imgMap[itemKey]!,
          "cantidad": alimentos[itemKey],
        });
      }
    });
  }

  void _playBuyAnimation(String imgPath) {
    setState(() {
      _animImg = imgPath;
      _showAnim = true;
    });
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd5b59d),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 5),
                _header(),
                const SizedBox(height: 5),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: ingredientes.length,
                    itemBuilder: (context, i) {
                      final item = ingredientes[i];
                      return Column(
                        children: [
                          Expanded(
                            child: Draggable<Map<String, dynamic>>(
                              data: {
                                "id": item["key"],
                                "img": item["img"],
                                "cantidad": 1,
                              },
                              feedback: Image.asset(
                                item["img"] as String,
                                width: 100,
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: Image.asset(item["img"] as String),
                              ),
                              child: Image.asset(item["img"] as String),
                            ),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () async {
                              final precio = item["precio"] as int;
                              if ((UsuarioSesion.monedas ?? 0) >= precio) {
                                UsuarioSesion.monedas =
                                    (UsuarioSesion.monedas ?? 0) - precio;
                                setState(() {});
                                await _guardarCompra(item["key"] as String);
                                _playBuyAnimation(item["img"] as String);
                                FirebaseFirestore.instance
                                    .collection("usuario")
                                    .doc(UsuarioSesion.email)
                                    .update({"monedas": UsuarioSesion.monedas});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Upss, no tienes suficientes monedas 😅",
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade400,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              (item["precio"] as int).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _footer(),
              ],
            ),
          ),
          if (_showAnim)
            Positioned.fill(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Image.asset(_animImg, height: 150),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: _infoBox(Icons.bar_chart, "Nivel: ${UsuarioSesion.nivel}"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _infoBox(
              Icons.attach_money,
              "Monedas: ${UsuarioSesion.monedas}",
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 107, 156),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DragTarget<Map<String, dynamic>>(
          onAccept: (alimento) async {
            // Obtener el precio del ingrediente arrastrado
            final item = ingredientes.firstWhere(
              (e) => e["key"] == alimento["id"],
            );
            final precio = item["precio"] as int;

            if ((UsuarioSesion.monedas ?? 0) >= precio) {
              // Descontar monedas
              UsuarioSesion.monedas = (UsuarioSesion.monedas ?? 0) - precio;
              setState(() {});

              // Actualizar Firestore
              await FirebaseFirestore.instance
                  .collection("usuario")
                  .doc(UsuarioSesion.email)
                  .update({"monedas": UsuarioSesion.monedas});

              // Guardar alimento en Firestore
              await _guardarCompra(alimento["id"]);

              // Animación
              _playBuyAnimation(alimento["img"]);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Upss, no tienes suficientes monedas 😅"),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, candidate, rejected) {
            return Image.asset(
              "assets/imagenes_general/canasta.png",
              height: 100,
            );
          },
        ),
        const SizedBox(width: 20),
        Image.asset("assets/gato/gato.png", height: 130),
        const SizedBox(width: 20),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapaScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Jugar",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
