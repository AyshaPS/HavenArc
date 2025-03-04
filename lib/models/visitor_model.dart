import 'package:cloud_firestore/cloud_firestore.dart';

class Visitor {
  final String id;
  final String name;
  final String purpose;
  final DateTime visitDate; // Ensure Firestore stores it as Timestamp

  Visitor({
    required this.id,
    required this.name,
    required this.purpose,
    required this.visitDate,
  });

  // ✅ Convert Firestore document to a Visitor object
  factory Visitor.fromMap(Map<String, dynamic> data, String documentId) {
    return Visitor(
      id: documentId,
      name: data['name'] ?? 'Unknown', // Default if missing
      purpose: data['purpose'] ?? 'No purpose given',
      visitDate: (data['visitDate'] != null) // ✅ Check if `visitDate` exists
          ? (data['visitDate'] as Timestamp).toDate()
          : DateTime.now(), // ✅ Use current time if missing
    );
  }

  get imageUrl => null;

  // ✅ Convert Visitor object to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'purpose': purpose,
      'visitDate': Timestamp.fromDate(
          visitDate), // Convert DateTime to Firestore Timestamp
    };
  }
}
