import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/facility_model.dart';

class FacilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Booking a facility
  Future<void> bookFacility(Facility facility) async {
    try {
      await _firestore.collection('facility_bookings').add(facility.toMap());
    } catch (e) {
      throw Exception('Failed to book facility: $e');
    }
  }

  // Fetch user bookings
  Stream<List<Facility>> getUserBookings() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    return _firestore
        .collection('facility_bookings')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Facility.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Cancel a facility booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('facility_bookings').doc(bookingId).delete();
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }
}
