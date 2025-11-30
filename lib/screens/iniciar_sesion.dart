import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'registro.dart';
import 'mapa.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarMensaje("Todos los campos son obligatorios");
      return;
    }

    setState(() => isLoading = true);

    try {
      final doc = await _firestore.collection("usuario").doc(email).get();

      if (!doc.exists) {
        _mostrarMensaje("El usuario no existe");
      } else {
        final datos = doc.data()!;
        String passBD = datos["contrasena"] ?? "";

        if (password != passBD) {
          _mostrarMensaje("Contraseña incorrecta");
        } else {
          _mostrarMensaje("Inicio de sesión exitoso");

          // Ir a MapaScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapaScreen()),
          );
        }
      }
    } catch (e) {
      _mostrarMensaje("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void _mostrarMensaje(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // 🔴 TU DISEÑO SE QUEDA IGUAL — SOLO CAMBIÉ EL onPressed
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8B6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: isLoading ? null : _login,     // <--- AQUÍ VA TU LOGIN REAL
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9AA2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Empezar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 30),

              Image.asset(
                "assets/imagenes_general/animales.png",
                height: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Aún no tienes una cuenta?',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistroScreen()),
                      );
                    },
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
