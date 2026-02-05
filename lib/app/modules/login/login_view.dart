import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controladores de texto para capturar lo que el usuario escribe
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("NEXO", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true, // Oculta la contraseña
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            // Obx escucha cambios en el controlador y redibuja solo este widget
            Obx(() => controller.isLoading.value 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    controller.email.value = emailController.text;
                    controller.password.value = passwordController.text;
                    controller.login();
                  },
                  child: const Text("Ingresar"),
                )
            ),
          ],
        ),
      ),
    );
  }
}