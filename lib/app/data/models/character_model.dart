class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin; 
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      gender: json['gender'] ?? 'Unknown', // Manejo de nulos
      // En la API, origin es un objeto {name: ..., url: ...}, tomamos solo el name
      origin: json['origin'] != null ? json['origin']['name'] : 'Unknown',
      image: json['image'],
    );
  }
}