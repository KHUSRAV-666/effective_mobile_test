class HeroModel {
  final int id;
  final String imageUrl;
  final String name;
  final String status;
  final String species;
  final String location;
  final String? description;
  final bool isFavorite;

  HeroModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.status,
    required this.species,
    required this.location,
    this.description,
    this.isFavorite = false,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id'] as int,
      imageUrl: json['image'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'unknown',
      species: json['species'] ?? 'unknown',
      location: json['location'] != null ? json['location']['name'] : 'unknown',
      description: json['description'],
      isFavorite: false,
    );
  }

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    return HeroModel(
      id: map['id'] as int,
      name: map['name'] ?? '',
      imageUrl: map['image'] ?? '',
      status: map['status'] ?? '',
      species: map['species'] ?? '',
      location: map['location'] ?? '',
      description: map['description'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'status': status,
      'species': species,
      'location': location,
      'description': description,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  HeroModel copyWith({bool? isFavorite}) {
    return HeroModel(
      id: id,
      imageUrl: imageUrl,
      name: name,
      status: status,
      species: species,
      location: location,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Hero{id: $id, name: $name, status: $status, isFavorite: $isFavorite}';
  }
}
