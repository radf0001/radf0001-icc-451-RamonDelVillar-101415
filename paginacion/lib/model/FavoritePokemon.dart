class FavoritePokemon {
  final int? id; // Hacer id opcional
  final String name;
  final String imageUrl;

  FavoritePokemon({
    this.id, // No es necesario que sea required
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  static FavoritePokemon fromMap(Map<String, dynamic> map) {
    return FavoritePokemon(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
}
