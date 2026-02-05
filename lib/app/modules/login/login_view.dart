import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LLAMAMOS A LA FUNCIÓN DEL LOGO AQUÍ
                _buildLogo(),
                
                const SizedBox(height: 40),
                const Text(
                  "BIENVENIDO A NEXO",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Explora el multiverso de Rick & Morty",
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                const SizedBox(height: 50),
                
                _buildTextField(
                  controller: controller.emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                
                _buildTextField(
                  controller: controller.passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                
                Obx(() => Column(
                  children: [
                    Text(
                      controller.isLoginMode.value ? "INICIAR SESIÓN" : "CREAR CUENTA",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.submit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isLoginMode.value ? Colors.greenAccent : Colors.blueAccent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.black)
                            : Text(controller.isLoginMode.value ? "INGRESAR" : "REGISTRARME"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () => controller.toggleMode(),
                      child: RichText(
                        text: TextSpan(
                          text: controller.isLoginMode.value 
                              ? "¿No tienes cuenta? " 
                              : "¿Ya tienes cuenta? ",
                          style: const TextStyle(color: Colors.white60),
                          children: [
                            TextSpan(
                              text: controller.isLoginMode.value ? "Regístrate" : "Inicia sesión",
                              style: const TextStyle(
                                color: Colors.greenAccent, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FUNCIÓN DEL LOGO CON LA IMAGEN DE RICK & MORTY
  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.greenAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 8,
          ),
        ],
      ),
child: ClipOval(
  child: CachedNetworkImage(
    imageUrl: 'https://4kwallpapers.com/images/walls/thumbs_3t/9494.png',
    height: 120,
    width: 120,
    fit: BoxFit.cover,
    placeholder: (context, url) => const SizedBox(
      height: 120,
      width: 120,
      child: Center(
        child: CircularProgressIndicator(color: Colors.greenAccent),
      ),
    ),
    // Manejo de errores
    errorWidget: (context, url, error) => const Icon(
      Icons.person, 
      size: 80, 
      color: Colors.greenAccent,
    ),
  ),
),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.greenAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
        filled: true,
        fillColor: const Color(0xFF1B252F),
      ),
    );
  }
}