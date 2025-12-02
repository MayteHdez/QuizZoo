import 'package:flutter/material.dart';
import 'config.dart';
import 'mercado.dart';
import 'pregunta.dart';
import 'casa.dart';
import '../services/audio_global_service.dart';
import '../services/history_music_service.dart';
import '../usuario_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cargarVolumen();
    // Detener música de historia
    HistoryMusicService().stopStoryMusic();

    // Encender música global
    AudioGlobalService().playGlobalMusic("musica/musicaglobal.mp3");
  }

  Future<void> _cargarVolumen() async {
    final prefs = await SharedPreferences.getInstance();

    double vol = prefs.getDouble("volume") ?? 0.2;
    bool mute = prefs.getBool("mute") ?? false;

    if (mute) {
      AudioGlobalService().mute();
    } else {
      AudioGlobalService().setVolume(vol);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // La app volvió al primer plano
      AudioGlobalService().playGlobalMusic("musica/musicaglobal.mp3");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  double topMate = 177;
  double leftMate = 131;

  double topGramatica = 208;
  double leftGramatica = 700;

  double topBiologia = 177;
  double leftBiologia = 629;

  double topLit = 208;
  double leftLit = 450;

  double topGeo = 208;
  double leftGeo = 202;

  double topHis = 177;
  double leftHis = 379;

  void actualizarCoordenadasSegunDificultad(int dificultad) {
    if (dificultad == 1) {
      topMate = 177;
      leftMate = 131;
      topGramatica = 208;
      leftGramatica = 700;
      topBiologia = 177;
      leftBiologia = 629;
      topLit = 208;
      leftLit = 450;
      topGeo = 208;
      leftGeo = 202;
      topHis = 177;
      leftHis = 379;
    } else if (dificultad == 2) {
      topMate = 130;
      leftMate = 78;
      topGeo = 247;
      leftGeo = 166;
      topHis = 130;
      leftHis = 322;
      topLit = 247;
      leftLit = 414;
      topBiologia = 130;
      leftBiologia = 572;
      topGramatica = 247;
      leftGramatica = 662;
    } else if (dificultad == 3) {
      topMate = 80;
      leftMate = 160;
      topGeo = 275;
      leftGeo = 118;
      topHis = 80;
      leftHis = 408;
      topLit = 275;
      leftLit = 364;
      topBiologia = 79;
      leftBiologia = 655;
      topGramatica = 275;
      leftGramatica = 612;
    } else if (dificultad == 4) {
      topMate = 75;
      leftMate = 200;
      topGeo = 299;
      leftGeo = 49;
      topHis = 75;
      leftHis = 448;
      topLit = 299;
      leftLit = 295;
      topBiologia = 74;
      leftBiologia = 695;
      topGramatica = 299;
      leftGramatica = 543;
    }

    setState(() {});
  }

  double generalTop = 177;
  double generalLeft = 131;
  String botonTema = "Matemáticas"; // tema actual
  int botonNivel = 1;

  int selectedDificultad = 1;

  final Map<int, int> dificultadMinimaNivel = {1: 1, 2: 5, 3: 10, 4: 15};

  void _abrirSelectorDificultad() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Text(
                "Selecciona dificultad",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              const SizedBox(height: 8),
              for (int d = 1; d <= 4; d++)
                ListTile(
                  leading: CircleAvatar(child: Text("$d"), radius: 14),
                  title: Text("Dificultad $d"),
                  subtitle:
                      (UsuarioSesion.nivel ?? 0) >= dificultadMinimaNivel[d]!
                          ? null
                          : Text(
                            "Se desbloquea en nivel ${dificultadMinimaNivel[d]}",
                            style: const TextStyle(fontSize: 12),
                          ),
                  trailing:
                      (UsuarioSesion.nivel ?? 0) >= dificultadMinimaNivel[d]!
                          ? (selectedDificultad == d
                              ? const Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 227, 153, 178),
                              )
                              : null)
                          : const Icon(Icons.lock, color: Colors.grey),
                  enabled:
                      (UsuarioSesion.nivel ?? 0) >= dificultadMinimaNivel[d]!,
                  onTap:
                      (UsuarioSesion.nivel ?? 0) >= dificultadMinimaNivel[d]!
                          ? () {
                            setState(() {
                              selectedDificultad = d;

                              // 🔥🔥 AQUÍ SE ACTUALIZAN LAS COORDENADAS 🔥🔥
                              actualizarCoordenadasSegunDificultad(d);
                            });

                            Navigator.pop(context);
                          }
                          : null,
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

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
                            moverBotonGeneral(
                              topMate,
                              leftMate,
                              "Matemáticas",
                              UsuarioSesion.dificultadSeleccionada,
                            );
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
                            moverBotonGeneral(
                              topGeo,
                              leftGeo,
                              "Geografía",
                              UsuarioSesion.dificultadSeleccionada,
                            );
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
                            moverBotonGeneral(
                              topHis,
                              leftHis,
                              "Historia",
                              UsuarioSesion.dificultadSeleccionada,
                            );
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
                            moverBotonGeneral(
                              topLit,
                              leftLit,
                              "Literatura",
                              UsuarioSesion.dificultadSeleccionada,
                            );
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
                            "Literatura",
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
                            moverBotonGeneral(
                              topBiologia,
                              leftBiologia,
                              "Biología",
                              UsuarioSesion.dificultadSeleccionada,
                            );
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
                            "Biología",
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
                            moverBotonGeneral(
                              topGramatica,
                              leftGramatica,
                              "Gramatica",
                              UsuarioSesion.dificultadSeleccionada,
                            );
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
                            "Gramatica",
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
                            UsuarioSesion.dificultadSeleccionada =
                                selectedDificultad;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PreguntaScreen(
                                      nivel: selectedDificultad,
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
                      UsuarioSesion.tipoMascota == "conejo"
                          ? "assets/conejo/conejo.png"
                          : UsuarioSesion.tipoMascota == "perro"
                          ? "assets/perro/perro.png"
                          : "assets/gato/gato_feliz.png", // valor por defecto
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
                          // Botón de Dificultad (pequeño)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _abrirSelectorDificultad,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  225,
                                  134,
                                  244,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.speed, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Dificultad: $selectedDificultad",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // 🔥 BOTÓN ANCHO (Configuración)
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

                          // 🔥 SEGUNDO BOTÓN ANCHO (Mercado)
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
