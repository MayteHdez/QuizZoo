import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../usuario_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'casa.dart';
import '../services/audio_global_service.dart';

class AlimentarScreen extends StatefulWidget {
const AlimentarScreen({super.key});

@override
State<AlimentarScreen> createState() => _AlimentarScreenState();
}

class _AlimentarScreenState extends State<AlimentarScreen>
with TickerProviderStateMixin {
List<Map<String, dynamic>> alimentosUser = [];

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
AudioGlobalService().playGlobalMusic("musica/musicaglobal.mp3");
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

_fadeAnimation =
    Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  parent: _fadeController,
  curve: Curves.easeOut,
));

_scaleAnimation =
    Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  parent: _fadeController,
  curve: Curves.easeIn,
));

}
Future<void> cargarAlimentos() async {
final doc = await FirebaseFirestore.instance
.collection("usuario")
.doc(UsuarioSesion.email)
.get();
Map<String, dynamic> alimentosDB = doc.data()?["alimentos"] ?? {};

setState(() {
  alimentosUser = alimentosDB.entries.map((e) {
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
await _fadeController.forward();
final alimento = alimentosUser[index];
// Restar 1 unidad del alimento
alimento["cantidad"] -= 1;

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
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CasaScreen()),
          ),
          child: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DragTarget<Map<String, dynamic>>(
            onAccept: (alimento) {
              final index = alimentosUser.indexOf(alimento);
              mascotaComio(index);
            },
            builder: (context, candidate, rejected) {
              return Center(child: Image.asset(mascota, height: 250));
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 130,
            child: ListView.builder(
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
                        Image.asset(alimento["img"], width: 100),
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
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Draggable<Map<String, dynamic>>(
                    data: alimento,
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
        ],
      ),
    ],
  ),
);
}
}

