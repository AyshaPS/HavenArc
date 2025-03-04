class FacilityModel {
  final String id;
  final String name;
  final String location;
  final bool availability;
  final String bookedBy;
  final List<String> availableSlots;
  final String imageUrl;
  final String description;

  FacilityModel({
    required this.id,
    required this.name,
    required this.location,
    required this.availability,
    this.bookedBy = '',
    this.availableSlots = const [],
    this.imageUrl = '',
    this.description = '',
  });

  factory FacilityModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FacilityModel(
      id: documentId,
      name: map['name'] as String? ?? 'Unknown Facility',
      location: map['location'] as String? ?? 'Unknown Location',
      availability: map['availability'] as bool? ?? true,
      bookedBy: map['bookedBy'] as String? ?? '',
      availableSlots: (map['availableSlots'] is List)
          ? List<String>.from(map['availableSlots'])
          : [],
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "location": location,
      "availability": availability,
      "bookedBy": bookedBy,
      "availableSlots": availableSlots,
      "imageUrl": imageUrl,
      "description": description,
    };
  }
}
