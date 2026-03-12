class HeroModel {
  final String id;
  final String imageUrl;
  final String name;
  final String status;
  final String species;
  final String location;
  final String? description;

  HeroModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.status,
    required this.species,
    required this.location,
    this.description,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id'].toString(),
      imageUrl: json['image'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'unknown',
      species: json['species'] ?? 'unknown',
      location: json['location'] != null ? json['location']['name'] : 'unknown',
      description: json['description'],
    );
  }

  @override
  String toString() {
    return 'Hero{id: $id, name: $name, status: $status}';
  }
}
