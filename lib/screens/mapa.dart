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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15), // margen lateral leve
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 107, 156),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // centra el contenido
                      children: [
                        const Icon(Icons.bar_chart, color: Colors.purple),
                        const SizedBox(width: 6),
                        const Text(
                          "Nivel",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10), // espacio pequeño entre los dos
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 107, 156),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.attach_money, color: Colors.purple),
                        const SizedBox(width: 6),
                        const Text(
                          "Monedas",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                mainAxisAlignment: MainAxisAlignment.start, //  cambia esto
                children: [
                  const SizedBox(height: 5), // espacio s
                  Image.asset(
                    "assets/gato/gato.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const SizedBox(height: 5), // espacio entre el gato a los botones
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // reduce el vertical
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Configuración",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Mercado",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
