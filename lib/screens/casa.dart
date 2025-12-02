import 'package:flutter/material.dart';
import 'package:quizapp/screens/alimentar.dart';
import 'mapa.dart';
import 'fondo.dart';
import '../usuario_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CasaScreen extends StatefulWidget {
const CasaScreen({super.key});

@override
State<CasaScreen> createState() => _CasaScreenState();
}

class _CasaScreenState extends State<CasaScreen> {
String _fondoActual = "assets/imagenes_general/castillo.png"; // Fondo por defecto
String _imagenMascota = "assets/gato/gato_feliz.png"; // Imagen de la mascota

@override
void initState() {
super.initState();
_cargarFondoElegido();
_checkHungerStatus();
_saveLastVisitTime();

_setImagenMascota(); // Inicializa imagen según tipo de mascota

}

// ------------------------------------------------------------------------
// 🔥 Inicializar imagen según tipo de mascota
// ------------------------------------------------------------------------
void _setImagenMascota() {
if (UsuarioSesion.tipoMascota == "conejo") {
_imagenMascota = "assets/conejo/conejo.png";
} else if (UsuarioSesion.tipoMascota == "perro") {
_imagenMascota = "assets/perro/perro.png";
} else {
_imagenMascota = "assets/gato/gato_feliz.png";
}
}

// ------------------------------------------------------------------------
// 🔥 Cargar fondo guardado
// ------------------------------------------------------------------------
void _cargarFondoElegido() async {
final prefs = await SharedPreferences.getInstance();
String? fondo = prefs.getString("fondoSeleccionado");
if (fondo != null && mounted) {
setState(() {
_fondoActual = fondo;
});
}
}

// ------------------------------------------------------------------------
// 🔥 Guardar última visita
// ------------------------------------------------------------------------
void _saveLastVisitTime() async {
final prefs = await SharedPreferences.getInstance();
prefs.setInt('lastVisit', DateTime.now().millisecondsSinceEpoch);
}

// ------------------------------------------------------------------------
// 🔥 Revisar si han pasado 3 horas y actualizar mascota
// ------------------------------------------------------------------------
void _checkHungerStatus() async {
final prefs = await SharedPreferences.getInstance();
int? lastVisit = prefs.getInt('lastVisit');
if (lastVisit == null) return;
DateTime last = DateTime.fromMillisecondsSinceEpoch(lastVisit);
DateTime now = DateTime.now();
Duration diff = now.difference(last);

if (diff.inHours >= 3) {
  setState(() {
    if (UsuarioSesion.tipoMascota == "conejo") {
      _imagenMascota = "assets/conejo/conejoasustado.png";
    } else if (UsuarioSesion.tipoMascota == "perro") {
      _imagenMascota = "assets/perro/asustado.png";
    } else {
      _imagenMascota = "assets/gato/gato_triste.png";
    }
  });

  _showHungerDialog();
}

}

// ------------------------------------------------------------------------
// 🔥 Pop-up de hambre
// ------------------------------------------------------------------------
void _showHungerDialog() {
showDialog(
context: context,
barrierDismissible: true,
builder: (context) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
Image.asset(_imagenMascota, height: 120),
const SizedBox(height: 10),
const Text(
"¡Estoy hambriento!",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Colors.red,
),
textAlign: TextAlign.center,
),
],
),
);
},
);
}

@override
void dispose() {
_saveLastVisitTime();
super.dispose();
}

// ------------------------------------------------------------------------
// 🔥 UI Principal
// ------------------------------------------------------------------------
@override
Widget build(BuildContext context) {
return Scaffold(
body: Container(
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage(_fondoActual),
fit: BoxFit.cover,
),
),
child: Column(
children: [
const SizedBox(height: 60),

        // NIVEL Y MONEDAS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bar_chart, color: Colors.purple),
                      const SizedBox(width: 6),
                      Text(
                        "Nivel: ${UsuarioSesion.nivel}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                      Text(
                        "Monedas: ${UsuarioSesion.monedas}",
                        style: const TextStyle(
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

        const SizedBox(height: 210),

        // MASCOTA INTERACTIVA
        GestureDetector(
          onTap: () async {
            // Al volver de alimentar, la mascota puede volver feliz
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlimentarScreen()),
            );

            if (result == true) {
              setState(() {
                _setImagenMascota(); // vuelve a la imagen feliz
                _saveLastVisitTime(); // reinicia el tiempo de hambre
              });
            }
          },
          child: Image.asset(
            _imagenMascota,
            height: 300,
          ),
        ),

        const SizedBox(height: 25),

        // BOTONES
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapaScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
              const SizedBox(width: 10),
             Expanded(
  child: ElevatedButton(
    onPressed: () async {
      // Abrimos FondoScreen y esperamos la ruta seleccionada
      final rutaSeleccionada = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FondoScreen()),
      );

      // Si seleccionó un fondo, actualizamos la UI inmediatamente
      if (rutaSeleccionada != null) {
        setState(() {
          _fondoActual = rutaSeleccionada;
        });
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: const Text(
      "Cambiar fondo",
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
);
}
}