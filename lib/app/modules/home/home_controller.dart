import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/character_model.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var characters = <Character>[].obs;
  var isLoading = true.obs;
  
  final _sessionBox = Hive.box('sessionBox'); 

  @override
  void onInit() {
    super.onInit();
    // 1. Cargar local inmediatamente
    loadLocalData(); 
    // 2. Intentar actualizar desde la nube
    fetchCharacters();
  }

  void loadLocalData() {
    var rawData = _sessionBox.get('characters_cache');
    if (rawData != null) {
      try {
        var decoded = json.decode(rawData as String) as List;
        characters.value = decoded.map((e) => Character.fromJson(e)).toList();
        isLoading.value = false; // Quitamos el loader porque ya hay datos que mostrar
        print("📦 Cache de Hive cargado exitosamente");
      } catch (e) {
        print("❌ Error parseando Hive: $e");
      }
    }
  } // <--- ESTA LLAVE FALTABA

  void fetchCharacters() async {
    try {
      // Si ya tenemos datos locales, no mostramos el loader circular
      if (characters.isEmpty) isLoading.value = true;

      var response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'))
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data['results'] as List;
        
        // Guardamos en Hive
        await _sessionBox.put('characters_cache', json.encode(list));
        
        // Actualizamos la lista reactiva
        characters.value = list.map((e) => Character.fromJson(e)).toList();
        print("🌐 API cargada y Hive actualizado");
      }
    } catch (e) {
      print("📡 Error de red o tiempo de espera agotado: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    var box = Hive.box('sessionBox');
    await box.put('isLoggedIn', false);
    Get.offAllNamed('/login');
  }
}