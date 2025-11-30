
class UsuarioSesion {

  static String? email;
  static String? nombre;        // Nombre del usuario
  static String? contrasena; 
   // Contraseña del usuario (opcional mantener en memoria)
  
  // Datos de la mascota
  static String? tipoMascota;   // "gato", "perro", "conejo"
  static String? nombreMascota; // Nombre que el usuario le ponga a la mascota

  // Progreso del usuario
  static int? monedas;
  static int? nivel;
  static int? puntos;

  /// Inicializar todos los valores desde Firestore o registro
  static void inicializar({
    required String emailUsuario,
    required String nombreUsuario,
    required String contrasenaUsuario,
    String? tipoM,
    String? nombreM,
    int? monedasUsuario,
    int? nivelUsuario,
    int? puntosUsuario,
  }) {
    email = emailUsuario;
    nombre = nombreUsuario;
    contrasena = contrasenaUsuario;
    tipoMascota = tipoM;
    nombreMascota = nombreM;
    monedas = monedasUsuario ?? 0;
    nivel = nivelUsuario ?? 1;
    puntos = puntosUsuario ?? 0;
  }

  /// Limpiar sesión al cerrar sesión
  static void limpiar() {
    email = null;
    nombre = null;
    contrasena = null;
    tipoMascota = null;
    nombreMascota = null;
    monedas = null;
    nivel = null;
    puntos = null;
  }
}
