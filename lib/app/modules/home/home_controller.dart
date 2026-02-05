import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  var isMoreLoading = false.obs;
  var hasMore = true.obs;

@override
  void onInit() {
    super.onInit();
    loadLocalData(); 
    fetchCharacters();
    
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        fetchNextPage();
      }
    });
  }

void fetchNextPage() async {
    if (isMoreLoading.value || !hasMore.value) return;

    try {
      isMoreLoading.value = true;
      currentPage++;

      var response = await http.get(
        Uri.parse('https://rickandmortyapi.com/api/character?page=$currentPage')
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data['results'] as List;

        var newCharacters = list.map((e) => Character.fromJson(e)).toList();
        characters.addAll(newCharacters); // Corregido: antes decía character

        if (data['info']['next'] == null) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      currentPage--;
      debugPrint('Error cargando siguiente página: $e');
    } finally {
      isMoreLoading.value = false;
    }
  }

void loadLocalData() {
    var rawData = _sessionBox.get('characters_cache');
    if (rawData != null) {
      try {
        var decoded = json.decode(rawData as String) as List;
        characters.value = decoded.map((e) => Character.fromJson(e)).toList();
        isLoading.value = false;
      } catch (e) {
        // En lugar de isLoggedIn = false (que no existe), hacemos esto:
        _sessionBox.put('isLoggedIn', false); 
        if (kDebugMode) {
          debugPrint("❌ Error Hive: $e");
        }
      }
    }
  }

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
      }
    } catch (e) {
        // 1. Apagamos el cargando para que la app no se quede bloqueada
      isLoading.value = false;
    // 2. Mostramos un aviso 
        Get.snackbar(
      "Ups! Algo salió mal",
      "No pudimos conectar con el servidor.",
      snackPosition: SnackPosition.BOTTOM,
    );
    } finally {
      isLoading.value = false;
    }
  }

@override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

void logout() async {
    try {
      await _auth.signOut();
      await _sessionBox.put('isLoggedIn', false);
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "No se pudo cerrar la sesión correctamente");
    }
  }
}