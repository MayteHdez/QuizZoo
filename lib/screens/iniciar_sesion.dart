import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IniciarSesionScreen extends StatefulWidget {
  const IniciarSesionScreen({super.key});

  @override
  State<IniciarSesionScreen> createState() => _IniciarSesionScreenState();
}

class _IniciarSesionScreenState extends State<IniciarSesionScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> sumarMonedas() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) return;

    DocumentReference docRef = db.collection("usuario").doc(email);

    // Sumar 5 monedas
    await db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        // Si el usuario no existe, lo crea con 5 monedas
        transaction.set(docRef, {"monedas": 5});
      } else {
        int monedas = snapshot.get("monedas") ?? 0;
        transaction.update(docRef, {"monedas": monedas + 5});
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Se sumaron 5 monedas a $email")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prueba Firestore")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo del usuario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sumarMonedas,
              child: const Text("Agregar 5 monedas"),
            ),
          ],
        ),
      ),
    );
  }
}
