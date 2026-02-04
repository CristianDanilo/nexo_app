import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importante
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // 1. Esto DEBE ser lo primero: prepara los canales de comunicación nativos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializamos Firebase ANTES de lanzar la app
  try {
    await Firebase.initializeApp(); 
    print("🔥 Firebase inicializado con éxito");
  } catch (e) {
    print("❌ Error al inicializar Firebase: $e");
  }

  // 3. Inicializamos Hive
  await Hive.initFlutter();
  await Hive.openBox('sessionBox');

  runApp(
    GetMaterialApp(
      title: "Nexo App",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(useMaterial3: true),
    ),
  );
}