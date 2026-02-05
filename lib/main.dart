import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error Firebase: $e");
  }

  // 2. Inicializar Hive y abrir el box
  await Hive.initFlutter();
  var box = await Hive.openBox('sessionBox');

  // 3. Leer si el usuario ya estaba logueado
  // Usamos una coma (,) no una "m"
  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

  runApp(
    GetMaterialApp(
      title: "Nexo App",
      debugShowCheckedModeBanner: false,
      // Si isLoggedIn es true, va a /home, si no a /login
      initialRoute: isLoggedIn ? '/home' : '/login',
      getPages: AppPages.routes,
      theme: ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00FF94), // Verde Neón Rick & Morty
    brightness: Brightness.dark,
    primary: const Color(0xFF00FF94),
    surface: const Color(0xFF12181F), // Fondo de tarjetas
  ),
  scaffoldBackgroundColor: const Color(0xFF0A0E14), // Fondo general
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0A0E14),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
  ),
),
    ),
  );
}