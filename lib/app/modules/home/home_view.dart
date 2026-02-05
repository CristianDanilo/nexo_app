import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Asegúrate de tener este import
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick & Morty Nexo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), 
            onPressed: () => controller.logout()
          )
        ],
      ),
      body: Obx(() {
        // 1. Si está cargando y NO hay personajes guardados aún, se muestra el loader
        if (controller.isLoading.value && controller.characters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Si terminó de cargar (o falló) y la lista sigue vacía
        if (controller.characters.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
                const SizedBox(height: 10),
                const Text("No hay datos disponibles offline."),
                const Text("Conéctate a internet una vez para descargar."),
                ElevatedButton(
                  onPressed: () => controller.fetchCharacters(),
                  child: const Text("Reintentar"),
                )
              ],
            ),
          );
        }

        // 3. Si hay personajes, los mostramos
        return ListView.builder(
          itemCount: controller.characters.length,
          itemBuilder: (context, index) {
            final character = controller.characters[index];
return Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      width: 1,
    ),
  ),
  child: ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    onTap: () => Get.toNamed('/details', arguments: character),
    leading: Hero(
      tag: character.id,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.blueAccent.withOpacity(0.5)],
          ),
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundImage: CachedNetworkImageProvider(character.image),
        ),
      ),
    ),
    title: Text(
      character.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
    subtitle: Row(
      children: [
        Icon(Icons.circle, 
          size: 10, 
          color: character.status == "Alive" ? Colors.greenAccent : Colors.redAccent
        ),
        const SizedBox(width: 6),
        Text("${character.status} - ${character.species}"),
      ],
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
  ),
);
          },
        );
      }),
    ); 
  }
}