import 'package:flutter/material.dart';
import 'config.dart';
import 'mercado.dart';
import 'pregunta.dart';
import 'casa.dart';
import '../services/audio_global_service.dart';
import '../services/history_music_service.dart';
import '../usuario_session.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    // Detener música de historia
    HistoryMusicService().stopStoryMusic();

    // Encender música global
    AudioGlobalService().playGlobalMusic("musica/musicaglobal.mp3");
  }

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

  double generalTop = 177;
  double generalLeft = 131;
  String botonTema = "Matemáticas"; // tema actual
  int botonNivel = 1;

  void moverBotonGeneral(double top, double left, String tema, int nivel) {
    setState(() {
      generalTop = top;
      generalLeft = left;
      botonTema = tema;
      botonNivel = nivel;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC8D0), // Rosa suave
      body: Column(
        children: [
          SizedBox(height: 25),
          // Encabezado: Nivel y Monedas
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ), // margen lateral leve
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 107, 156),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // centra el contenido
                      children: [
                        const Icon(Icons.bar_chart, color: Colors.purple),
                        const SizedBox(width: 6),
                        Text(
                          "Nivel: ${UsuarioSesion.nivel}",
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.attach_money, color: Colors.purple),
                        const SizedBox(width: 6),
                        Text(
                          "Monedas: ${UsuarioSesion.monedas}",
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

          // Mapa con flechas centradas sobre él y botones encima
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Stack(
                    children: [
                      SizedBox(
                        // 👈 le da un alto fijo al mapa y a todo lo que está encima
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Image.asset(
                          "assets/imagenes_general/mapa.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Botones sobre el mapa:
                      // Botón Tema 1
                      Positioned(
                        top: 175,
                        left: 160,
                        child: ElevatedButton(
                          onPressed: () {
                            moverBotonGeneral(177, 131, "Matemáticas", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              222,
                              79,
                              247,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ), // 👈 más pequeño
                            minimumSize: const Size(
                              50,
                              30,
                            ), // 👈 tamaño mínimo más chico
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // 👈 evita agrandado automático
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // bordes redondeados pero suaves
                            ),
                          ),
                          child: const Text(
                            "Matemáticas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  13, // 👈 texto un poco más pequeño también
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //Boton Tema 2
                      Positioned(
                        top: 210,
                        left: 130,
                        child: ElevatedButton(
                          onPressed: () {
                            moverBotonGeneral(208, 202, "Geografía", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              222,
                              79,
                              247,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ), // 👈 más pequeño
                            minimumSize: const Size(
                              50,
                              30,
                            ), // 👈 tamaño mínimo más chico
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // 👈 evita agrandado automático
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // bordes redondeados pero suaves
                            ),
                          ),
                          child: const Text(
                            "Geografía",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  13, // 👈 texto un poco más pequeño también
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Botón Tema 3
                      Positioned(
                        top: 175,
                        left: 410,
                        child: ElevatedButton(
                          onPressed: () {
                            moverBotonGeneral(177, 379, "Historia", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              222,
                              79,
                              247,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ), // 👈 más pequeño
                            minimumSize: const Size(
                              50,
                              30,
                            ), // 👈 tamaño mínimo más chico
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // 👈 evita agrandado automático
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // bordes redondeados pero suaves
                            ),
                          ),
                          child: const Text(
                            "Historia",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  13, // 👈 texto un poco más pequeño también
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //Boton Tema 4
                      Positioned(
                        top: 210,
                        left: 380,
                        child: ElevatedButton(
                          onPressed: () {
                            moverBotonGeneral(208, 450, "Deportes", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              222,
                              79,
                              247,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ), // 👈 más pequeño
                            minimumSize: const Size(
                              50,
                              30,
                            ), // 👈 tamaño mínimo más chico
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // 👈 evita agrandado automático
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // bordes redondeados pero suaves
                            ),
                          ),
                          child: const Text(
                            "Deportes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  13, // 👈 texto un poco más pequeño también
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Botón Tema 5
                      Positioned(
                        top: 175,
                        left: 660,
                        child: ElevatedButton(
                          onPressed: () {
                            moverBotonGeneral(177, 629, "Entretenimiento", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              222,
                              79,
                              247,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ), // 👈 más pequeño
                            minimumSize: const Size(
                              50,
                              30,
                            ), // 👈 tamaño mínimo más chico
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // 👈 evita agrandado automático
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // bordes redondeados pero suaves
                            ),
                          ),
                          child: const Text(
                            "Entretenimiento",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  13, // 👈 texto un poco más pequeño también
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //Boton Tema 6
                      Positioned(
                        top: 210,
                        left: 630,
                        child: ElevatedButton(
                          onPressed: () {
                            moverBotonGeneral(208, 700, "Curiosidades", 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              222,
                              79,
                              247,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ), // 👈 más pequeño
                            minimumSize: const Size(
                              50,
                              30,
                            ), // 👈 tamaño mínimo más chico
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // 👈 evita agrandado automático
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // bordes redondeados pero suaves
                            ),
                          ),
                          child: const Text(
                            "Curiosidades",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  13, // 👈 texto un poco más pequeño también
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      //Boton general
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        top: generalTop,
                        left: generalLeft,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PreguntaScreen(
                                  nivel: botonNivel,
                                  tema: botonTema,
                                  preguntasUsadas: [],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFC8D0,
                            ).withOpacity(0.8),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(4),
                            minimumSize: const Size(30, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 3,
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Flechas centradas en el mapa (como antes)
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // GATO
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CasaScreen(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/gato/gato.png",
                      height: MediaQuery.of(context).size.height * 0.22,
                    ),
                  ),

                  // BOTONES ANCHOS
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔥 BOTÓN ANCHO
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ConfigScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
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

                          const SizedBox(height: 10),

                          // 🔥 SEGUNDO BOTÓN ANCHO
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const IngredientesScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
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
