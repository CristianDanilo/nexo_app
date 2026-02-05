import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/character_model.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Character character = Get.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                character.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: Hero(
                tag: character.id,
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  fit: BoxFit.cover,
                  // Filtro oscuro para que el nombre se lea mejor arriba
                  color: Colors.black.withOpacity(0.2),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Información General",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 10),
                  _detailRow("Especie", character.species, Colors.blueAccent),
                  _detailRow("Estado", character.status, 
                    character.status == "Alive" ? Colors.greenAccent : Colors.redAccent),
                  // _detailRow("Género", character.gender, Colors.purpleAccent),
                  // _detailRow("Origen", character.origin.name, Colors.orangeAccent),
                  // const SizedBox(height: 30),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Este personaje pertenece al multiverso de la serie. Los datos han sido sincronizados localmente para su visualización offline.",
                    style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MÉTODO AUXILIAR PARA LAS FILAS (Importante incluirlo)
  Widget _detailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.white60)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}