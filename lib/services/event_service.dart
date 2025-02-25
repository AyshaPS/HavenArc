import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> createEvent(Event event) async {
    try {
      await _eventsCollection.doc(event.id).set(event.toMap());
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<List<Event>> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _eventsCollection.get();
      return snapshot.docs
          .map((doc) =>
              Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _eventsCollection.doc(event.id).update(event.toMap());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsCollection.doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
}
