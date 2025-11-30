import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Comentado para pruebas
import 'registro_m.dart';
import 'iniciar_sesion.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // 🔹 Comentado

  bool isLoading = false;

  Future<void> _registrarUsuario() async {
    String email = emailController.text.trim();
    String nombre = nombreController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || nombre.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _mostrarError("Todos los campos son obligatorios");
      return;
    }

    if (password != confirmPassword) {
      _mostrarError("Las contraseñas no coinciden");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var usuarioExistente = await _firestore.collection("usuario").doc(email).get();

      if (usuarioExistente.exists) {
        _mostrarError("El correo ya está registrado");
      } else {
        await _firestore.collection("usuario").doc(email).set({
          "nombre": nombre,
          "contrasena": password,         
          "nombre_m": "",
          "tipo_m": "",
          "puntos": 0,
          "nivel": 1,
          "monedas": 0,

        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso")),
        );
      }
      


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegistroMascotaScreen(email: email),
        ),
      );

    } catch (e) {
      _mostrarError("Error al registrar: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          color: const Color(0xFFF4DDE1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Registro",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre de usuario",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirmar Contraseña",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: isLoading ? null : _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Continuar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 30),

              Flexible(
                child: Image.asset(
                  "assets/imagenes_general/animales.png",
                  fit: BoxFit.contain,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¿Ya tienes una cuenta? ",
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Inicia sesión",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
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