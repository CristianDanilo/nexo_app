import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/character_model.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos el personaje pasado por argumentos
    final Character character = Get.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14), // Fondo oscuro coherente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          character.name,
          style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Imagen con Hero y borde neón
            Center(
              child: Hero(
                tag: character.id,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.greenAccent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: character.image,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Tarjeta de información
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B252F), // Color de las tarjetas del Home
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.face, "Especie", character.species),
                    const Divider(color: Colors.white10, height: 30),
                    _buildInfoRow(Icons.info_outline, "Estado", character.status, 
                        color: character.status == "Alive" ? Colors.greenAccent : Colors.redAccent),
                    const Divider(color: Colors.white10, height: 30),
                    _buildInfoRow(Icons.transgender, "Género", character.gender),
                    const Divider(color: Colors.white10, height: 30),
                    _buildInfoRow(Icons.location_on_outlined, "Origen", character.origin),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para las filas de información
Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start, // Alinea al inicio si hay varias líneas
    children: [
      Icon(icon, color: Colors.greenAccent, size: 28),
      const SizedBox(width: 15),
      // El Expanded es la clave: obliga al Column a no estirarse más del ancho disponible
      Expanded( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),
            Text(
              value,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true, // Permite que el texto baje a la siguiente línea
              overflow: TextOverflow.visible, // O puedes usar TextOverflow.ellipsis para poner "..."
            ),
          ],
        ),
      ),
    ],
  );
}
}