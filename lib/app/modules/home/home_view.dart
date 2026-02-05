import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick & Morty Nexo"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => controller.logout())
        ],
      ),
    body: Obx(() {
      // 1. Si está cargando y NO hay personajes guardados aún, mostramos el loader
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

      // 3. Si hay personajes (ya sea de Hive o de la API), los mostramos
      return ListView.builder(
        itemCount: controller.characters.length,
        itemBuilder: (context, index) {
          final character = controller.characters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(character.image),
              ),
              title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${character.species} - ${character.status}"),
              trailing: Icon(
                Icons.circle,
                color: character.status == "Alive" ? Colors.green : Colors.red,
                size: 12,
              ),
            ),
          );
        },
      );
    }),
    );
  }
}