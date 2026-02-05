import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/character_model.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recuperamos el personaje enviado por los argumentos
    final Character character = Get.arguments;

return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: Column(
        children: [
          Hero(
            tag: character.id,
            child: CachedNetworkImage( // <--- CAMBIO AQUÍ
              imageUrl: character.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              // Qué mostrar mientras carga (con internet)
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              // Qué mostrar si no hay internet y no está en cache
              errorWidget: (context, url, error) => const Icon(Icons.person, size: 100),
            ),
          ),
          const SizedBox(height: 20),
          // El resto de tus datos (Nombre, Especie, etc.)
          Text(character.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Especie: ${character.species}"),
          Text("Estado: ${character.status}"),
        ],
      ),
    );
  }
  Widget _detailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}