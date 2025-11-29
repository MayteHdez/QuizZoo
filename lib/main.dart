
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/pantalla_carga.dart';
import 'screens/registro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool mostrarPantallaCarga = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 8),() { //cambiar a 20 solo esta asi para pruebas
      setState(() {
        mostrarPantallaCarga = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      home: mostrarPantallaCarga
          ? const PantallaCarga()
          : const RegistroScreen(),
    );
  }
}
