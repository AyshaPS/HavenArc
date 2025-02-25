import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String description;
  DateTime date;
  String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });

  // Convert Event object to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date':
          Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
      'location': location,
    };
  }

  // Create Event object from Firestore Map
  factory Event.fromMap(Map<String, dynamic> map, String documentId) {
    return Event(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
      location: map['location'] ?? '',
    );
  }
}
