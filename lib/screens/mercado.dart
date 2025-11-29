import 'package:flutter/material.dart';

class IngredientesScreen extends StatefulWidget {
  const IngredientesScreen({super.key});

  @override
  State<IngredientesScreen> createState() => _IngredientesScreenState();
}

class _IngredientesScreenState extends State<IngredientesScreen> {
  final ingredientes = [
    {"img": "assets/imagenes_general/pollo.png", "precio": 25},
    {"img": "assets/imagenes_general/plato1.png", "precio": 10},
    {"img": "assets/imagenes_general/pescado.png", "precio": 25},
    {"img": "assets/imagenes_general/brocoli.png", "precio": 15},

    {"img": "assets/imagenes_general/zanahoria.png", "precio": 15},
    {"img": "assets/imagenes_general/chicharo.png", "precio": 10},
    {"img": "assets/imagenes_general/moras.png", "precio": 10},
    {"img": "assets/imagenes_general/salmon.png", "precio": 25},

    {"img": "assets/imagenes_general/plato2.png", "precio": 10},
    {"img": "assets/imagenes_general/lata.png", "precio": 30},
    {"img": "assets/imagenes_general/hoja.png", "precio": 10},
    {"img": "assets/imagenes_general/melon.png", "precio": 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd5b59d), // color parecido al de la imagen
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 5),
            // 🔵 ENCABEZADO
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
          const SizedBox(height: 5),
            // 🟠 GRID DE INGREDIENTES
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.8, // ajusta tamaño similar al screenshot
                ),
                itemCount: ingredientes.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          ingredientes[i]["img"] as String,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // 🔘 BOTÓN DEL PRECIO
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          (ingredientes[i]["precio"] as int).toString(),
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

            // 🧺 CESTA + 🐱 GATITO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/imagenes_general/canasta.png",
                  height: 100,
                ),
                const SizedBox(width: 20), // separa las imágenes
                Image.asset(
                  "assets/gato/gato.png",
                  height: 130,
                ),
              ],
            ),
                      ],
        ),
      ),
    );
  }

  // 🔵 Método para botones de encabezado
  Widget headerButton(String img, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Image.asset(img, height: 20),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
