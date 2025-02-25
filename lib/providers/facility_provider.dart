import 'package:flutter/material.dart';
import '../models/facility_model.dart';
import '../services/facility_service.dart';

class FacilityProvider with ChangeNotifier {
  final FacilityService _facilityService = FacilityService();
  List<Facility> _bookings = [];

  List<Facility> get bookings => _bookings;

  Future<void> fetchUserBookings() async {
    _bookings = await _facilityService.getUserBookings().first;
    notifyListeners();
  }

  Future<void> bookFacility(Facility facility) async {
    await _facilityService.bookFacility(facility);
    await fetchUserBookings();
  }

  Future<void> cancelBooking(String bookingId) async {
    await _facilityService.cancelBooking(bookingId);
    await fetchUserBookings();
  }
}
