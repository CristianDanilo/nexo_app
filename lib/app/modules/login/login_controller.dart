import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isLoginMode = true.obs; 

  void toggleMode() {
    isLoginMode.value = !isLoginMode.value;
  }
  
  void submit() {
    if (isLoginMode.value) {
      login();
    } else {
      register();
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackbar("Campos obligatorios", "Por favor, completa todos los campos");
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      var box = Hive.box('sessionBox');
      await box.put('isLoggedIn', true);

      Get.offAllNamed('/home');
    } catch (e) {
      _showErrorSnackbar("Error de ingreso", "Credenciales incorrectas o problema de conexión");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackbar("Campos vacíos", "Por favor completa todos los datos.");
      return;
    }

    if (password.length < 6) {
      _showErrorSnackbar("Contraseña muy corta", "Debe tener al menos 6 caracteres.");
      return;
    }

    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var box = Hive.box('sessionBox');
      await box.put('isLoggedIn', true);
      Get.offAllNamed('/home');

    } on FirebaseAuthException catch (e) {
      String mensaje = "Ocurrió un error";
      if (e.code == 'email-already-in-use') {
        mensaje = "Este correo ya está registrado.";
      } else if (e.code == 'invalid-email') {
        mensaje = "El formato del correo no es válido.";
      }
      _showErrorSnackbar("Error de Registro", mensaje);
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
} // La llave ahora cierra TODA la clase correctamente