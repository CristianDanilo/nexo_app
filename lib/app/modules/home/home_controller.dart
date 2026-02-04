import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/character_model.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Variables observables
  var characters = <Character>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCharacters(); // Cargar datos al iniciar
  }

  void fetchCharacters() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
      
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data['results'] as List;
        characters.value = list.map((e) => Character.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo conectar con el multiverso");
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}