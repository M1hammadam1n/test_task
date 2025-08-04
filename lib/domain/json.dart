
class Character {
  final String name;
  final String image;
  final String gender;

  Character({required this.name, required this.image, required this.gender});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}
