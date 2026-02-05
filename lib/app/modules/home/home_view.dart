import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home_controller.dart';
import '../../data/models/character_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0A0E14), // Fondo general oscuro
    appBar: AppBar(
      backgroundColor: const Color(0xFF0A0E14),
      elevation: 0,
      title: const Text(
        "Rick & Morty Nexo",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.greenAccent), 
          onPressed: () => controller.logout()
        )
      ],
    ),
      body: Obx(() {
        if (controller.isLoading.value && controller.characters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.characters.isEmpty) {
          return _buildEmptyState();
        }

        // AGREGADO EL RETURN AQUÍ
        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.characters.length + (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < controller.characters.length) {
              final character = controller.characters[index];
              // USAMOS EL MÉTODO QUE CREASTE ABAJO
              return _buildCharacterCard(character);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent),
                ),
              );
            }
          },
        );
      }),
    );
  }

  // Tu función para la tarjeta (está perfecta)
Widget _buildCharacterCard(Character character) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF1B252F), // Fondo oscuro que pusimos antes
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.greenAccent.withOpacity(0.1), // Borde neón sutil
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      onTap: () => Get.toNamed('/details', arguments: character),
      leading: Hero(
        tag: character.id,
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.greenAccent, width: 1),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[900],
            backgroundImage: CachedNetworkImageProvider(character.image),
          ),
        ),
      ),
      title: Text(
        character.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 18, 
          color: Colors.white
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: character.status == "Alive" ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 6),
          Text(
            "${character.status} - ${character.species}",
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios, 
        size: 14, 
        color: Colors.greenAccent
      ),
    ),
  );
}

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("No hay datos disponibles."),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.fetchCharacters(),
            child: const Text("Reintentar"),
          )
        ],
      ),
    );
  }
}