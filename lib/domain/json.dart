class RickMorty {
  final int id;
  final String name;
  final String image;
  final String status;
  final String gender;
  final String species;
  RickMorty({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.gender,
    required this.species,
  });

  factory RickMorty.fromJson(Map<String, dynamic> json) {
    return RickMorty(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      gender: json['gender'] ?? '',
      species: json['species'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'gender': gender,
      'species': species,
    };
  }
}
