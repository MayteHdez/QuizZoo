import 'package:flutter/material.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 150,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 150,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC8D0), // Rosa suave
      body: Column(
        children: [
          // Encabezado: Nivel y Monedas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 107, 156),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.bar_chart, color: Colors.purple),
                      const SizedBox(width: 6),
                      Text(
                        "Nivel",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 107, 156),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.purple),
                      const SizedBox(width: 6),
                      Text(
                        "Monedas",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mapa con flechas centradas sobre él
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.58,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Image.asset(
                    "assets/imagenes_general/mapa.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Flechas centradas en el mapa
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _scrollLeft,
                    icon: const Icon(Icons.arrow_circle_left_rounded),
                    iconSize: 50,
                    color: const Color.fromARGB(255, 164, 75, 180),
                  ),
                  IconButton(
                    onPressed: _scrollRight,
                    icon: const Icon(Icons.arrow_circle_right_rounded),
                    iconSize: 50,
                    color: const Color.fromARGB(255, 164, 75, 180),
                  ),
                ],
              ),
            ],
          ),

          // Fondo rosa con gato + botones
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFFFC8D0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gato más grande pero sin salirse
                  Image.asset("assets/gato/gato.png",
                      height: MediaQuery.of(context).size.height * 0.2),
                  const SizedBox(height: 10),

                  // Botones más cerca del gato
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Configuración",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // ← texto blanco
                            fontWeight: FontWeight.bold, // opcional, se ve mejor
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Mercado",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white, // ← texto blanco
                            fontWeight: FontWeight.bold, // opcional, se ve mejor
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
