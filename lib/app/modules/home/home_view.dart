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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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