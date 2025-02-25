class Visitor {
  final String id;
  final String name;
  final String purpose;
  final String visitDate;
  final String imageUrl;

  Visitor({
    required this.id,
    required this.name,
    required this.purpose,
    required this.visitDate,
    required this.imageUrl,
  });

  factory Visitor.fromMap(Map<String, dynamic> data, String documentId) {
    print("📢 Mapping Firestore Data for Visitor ID: $documentId");
    print("🔥 Data Received: $data");

    return Visitor(
      id: documentId,
      name: data['name'] is String ? data['name'] ?? 'Unknown' : 'Unknown',
      purpose: data['purpose'] is String
          ? data['purpose'] ?? 'Not specified'
          : 'Not specified',
      visitDate:
          data['visitDate'] is String ? data['visitDate'] ?? 'N/A' : 'N/A',
      imageUrl: data['imageUrl'] is String ? data['imageUrl'] ?? '' : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'purpose': purpose,
      'visitDate': visitDate,
      'imageUrl': imageUrl,
    };
  }
}
