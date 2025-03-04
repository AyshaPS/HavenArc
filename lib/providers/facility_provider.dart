import 'package:flutter/material.dart';
import '../models/facility_model.dart';
import '../services/facility_service.dart';

class FacilityProvider with ChangeNotifier {
  final FacilityService _facilityService = FacilityService();
  List<FacilityModel> _bookings = [];
  bool _isLoading = false;

  /// ✅ Getter to access facility bookings
  List<FacilityModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  /// ✅ Fetch user's facility bookings
  Future<void> fetchUserBookings() async {
    try {
      _isLoading = true;
      notifyListeners();

      _bookings = await _facilityService.getUserBookings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("❌ Error fetching user bookings: $e");
    }
  }

  /// ✅ Book a facility and refresh bookings
  Future<void> bookFacility(FacilityModel facility) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _facilityService.bookFacility(facility);
      await fetchUserBookings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("❌ Error booking facility: $e");
    }
  }

  /// ✅ Cancel a facility booking and refresh bookings
  Future<void> cancelBooking(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _facilityService.cancelBooking(bookingId);
      await fetchUserBookings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("❌ Error canceling booking: $e");
    }
  }
}
