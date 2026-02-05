import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart'; // Importante
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/character_model.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var characters = <Character>[].obs;
  var isLoading = true.obs;
  
  // 1. Añadimos esta bandera para evitar que entre dos veces
  bool _isAlreadyLoaded = false;

  final _sessionBox = Hive.box('sessionBox'); 

  @override
  void onReady() {
    super.onReady();
    // 2. Solo carga si no ha cargado antes
    if (!_isAlreadyLoaded) {
      loadData();
      _isAlreadyLoaded = true;
    }
  }

  void loadData() async {
    // Usamos try-catch para que si algo falla no se quede trabado
    try {
      var localData = _sessionBox.get('characters_cache');
      
      if (localData != null) {
        var decodedData = json.decode(localData as String) as List;
        characters.value = decodedData.map((e) => Character.fromJson(e)).toList();
        isLoading(false);
        print("📦 Datos cargados desde Hive");
      } else {
        fetchCharacters();
      }
    } catch (e) {
      print("Error en loadData: $e");
      fetchCharacters(); // Si el cache falla, intenta la API
    }
  }

  void fetchCharacters() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
      
      if (response.statusCode == 200) {
        await _sessionBox.put('characters_cache', response.body);
        var data = json.decode(response.body);
        var list = data['results'] as List;
        characters.value = list.map((e) => Character.fromJson(e)).toList();
        print("🌐 Datos cargados desde la API");
      }
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}