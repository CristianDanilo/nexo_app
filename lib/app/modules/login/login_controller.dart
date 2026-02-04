import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // 1. Instancia de Firebase Auth para comunicarnos con la nube
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 2. Variables reactivas (.obs). GetX redibujará la pantalla cuando estas cambien.
  var isLoading = false.obs;

  // 3. Función para iniciar sesión
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Por favor llena todos los campos");
      return;
    }

    try {
      isLoading.value = true; // Iniciamos la carga
      
      // Intento de login en Firebase
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // Si tiene éxito, mandamos al Home (la crearemos luego)
      Get.offAllNamed('/home'); 
      
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de Firebase
      String message = "Ocurrió un error";
      if (e.code == 'user-not-found') message = "Usuario no encontrado";
      if (e.code == 'wrong-password') message = "Contraseña incorrecta";
      
      Get.snackbar("Login Fallido", message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // Detenemos la carga pase lo que pase
    }
  }
}