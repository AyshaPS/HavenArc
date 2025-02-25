import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];

  List<Event> get events => _events;

  Future<void> fetchEvents() async {
    _events = await _eventService.fetchEvents();
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _eventService.createEvent(event);
    await fetchEvents();
  }

  Future<void> removeEvent(String eventId) async {
    await _eventService.deleteEvent(eventId);
    await fetchEvents();
  }
}
