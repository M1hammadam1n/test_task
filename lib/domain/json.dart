class Character {
  final String name;
  final String image;
  final String gender;
  final int id;

  Character({
    required this.name,
    required this.image,
    required this.gender,
    required this.id,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}

//Здесь расположен json модели
