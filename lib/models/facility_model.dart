class Facility {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Facility({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  /// Factory method to create a Facility from Firestore data
  factory Facility.fromMap(Map<String, dynamic> map, String documentId) {
    return Facility(
      id: documentId,
      name: map['name'] ?? 'Unknown Facility',
      description: map['description'] ?? 'No description available',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  /// Convert Facility object to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
