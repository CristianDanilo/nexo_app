import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variables para capturar el texto (asegúrate de usarlas en tu vista)
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  void login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar("Error", "Por favor llena todos los campos");
      return;
    }

    try {
      isLoading.value = true;

      // 1. Intentamos login con Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      if (userCredential.user != null) {
        // 2. GUARDAMOS EN HIVE EL ESTADO EXITOSO
        var box = Hive.box('sessionBox');
        await box.put('isLoggedIn', true);
        
        Get.offAllNamed('/home');
      }
    } catch (e) {
      // 3. MANEJO DE ERROR OFFLINE O CREDENCIALES
      if (e.toString().contains('network-request-failed')) {
        Get.snackbar("Modo Offline", "No hay internet para validar nuevas credenciales");
      } else {
        Get.snackbar("Error de acceso", "Correo o contraseña incorrectos");
      }
    } finally {
      isLoading.value = false;
    }
  }
}