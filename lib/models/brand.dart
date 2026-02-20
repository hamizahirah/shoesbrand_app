import 'dart:convert';

class Brand {
  final int? id;
  final String name;
  final String description;
  Brand({
    this.id,
    required this.name,
    required this.description,
  });
  // Convert a Brand into a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Create a Brand instance from a Map.
  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
  // Convert a Brand to JSON.
  String toJson() => json.encode(toMap());
  // Create a Brand from a JSON string.
  factory Brand.fromJson(String source) => Brand.fromMap(json.decode(source));
  @override
  String toString() => 'Brand(id: $id, name: $name, description: $description)';
}
