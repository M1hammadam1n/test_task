class Character {
  final String name;
  final String image;
  final String gender;
  final int id;
  final String status;
  final String species;
  final String created;

  Character({
    required this.name,
    required this.image,
    required this.gender,
    required this.id,
    required this.status,
    required this.species,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      created: json['created'] ?? '',
    );
  }
}

//Здесь расположен json модели
