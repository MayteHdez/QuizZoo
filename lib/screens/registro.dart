import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Comentado para pruebas
import 'registro_m.dart';
import 'iniciar_sesion.dart';
import '../usuario_session.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // 🔹 Comentado

  bool isLoading = false;
  bool mostrarPassword = false;
  bool mostrarConfirmPassword = false;
  String? errorEmail;
  String? errorNombre;
  String? errorPassword;
  String? errorConfirmPassword;

  bool esCorreoValido(String email) {
    //revisa si el correo es valido
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool esPasswordValido(String password) {
    // Min 8 caracteres
    if (password.length < 8) return false;
    // Al menos una mayúscula
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    // Al menos una minúscula
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    // Al menos un número
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  Future<void> _registrarUsuario() async {
    String email = emailController.text.trim();
    String nombre = nombreController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    // VALIDACIÓN VISUAL COMPLETA
    setState(() {
      errorEmail =
          email.isEmpty || !esCorreoValido(email)
              ? "Ingresa un correo inválido"
              : null;
      errorNombre = nombre.isEmpty ? "El nombre es obligatorio" : null;
      errorPassword =
          !esPasswordValido(password)
              ? "Contraseña inválida (8 caracteres, mayúscula, número)"
              : null;
      errorConfirmPassword =
          password != confirmPassword ? "Las contraseñas no coinciden" : null;
    });
    // Si hay errores → detener registro
    if (errorEmail != null ||
        errorNombre != null ||
        errorPassword != null ||
        errorConfirmPassword != null) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      var usuarioExistente =
          await _firestore.collection("usuario").doc(email).get();

      if (usuarioExistente.exists) {
        _mostrarError("Este correo ya está registrado. Inicia sesión.");

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });

        return;
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

        UsuarioSesion.inicializar(
          emailUsuario: email,
          nombreUsuario: nombre,
          contrasenaUsuario: password,
          tipoM: "", // todavía no elige mascota
          nombreM: "", // todavía no tiene nombre de mascota
          monedasUsuario: 0,
          nivelUsuario: 1,
          puntosUsuario: 0,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Registro exitoso")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistroMascotaScreen(email: email),
          ),
        );
      }
      ;
    } catch (e) {
      _mostrarError("Error al registrar: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
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
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      errorEmail = "El correo es obligatorio";
                    } else if (!esCorreoValido(value)) {
                      errorEmail = "Formato de correo inválido";
                    } else {
                      errorEmail = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                  errorText: errorEmail,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: nombreController,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isEmpty) {
                      errorNombre = "El nombre es obligatorio";
                    } else {
                      errorNombre = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  errorText: errorNombre,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: !mostrarPassword,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      errorPassword = "La contraseña es obligatoria";
                    } else if (!esPasswordValido(value)) {
                      errorPassword =
                          "Debe tener 8+ caracteres, mayúscula, número";
                    } else {
                      errorPassword = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  errorText: errorPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarPassword = !mostrarPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: confirmPasswordController,
                obscureText: !mostrarConfirmPassword,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      errorConfirmPassword = "Debes confirmar la contraseña";
                    } else if (value != passwordController.text) {
                      errorConfirmPassword = "Las contraseñas no coinciden";
                    } else {
                      errorConfirmPassword = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: "Confirmar Contraseña",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  errorText: errorConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarConfirmPassword = !mostrarConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: isLoading ? null : _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child:
                    isLoading
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
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
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
