import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/facility_model.dart';

class FacilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Fetch user's facility bookings
  Future<List<FacilityModel>> getUserBookings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      var querySnapshot = await _firestore
          .collection("facilities")
          .where("bookedBy", isEqualTo: user.uid)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data(); // ✅ Ensure correct casting
        return FacilityModel.fromMap(data, doc.id); // ✅ Correct usage
      }).toList();
    } catch (e) {
      print("❌ Error fetching user bookings: $e");
      return [];
    }
  }

  /// ✅ Book a facility
  Future<void> bookFacility(FacilityModel facility) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await _firestore.collection("facilities").doc(facility.id).update({
        "availability": false,
        "bookedBy": user.uid,
      });
      print("✅ Facility booked successfully: ${facility.id}");
    } catch (e) {
      print("❌ Error booking facility: $e");
      throw Exception("Failed to book facility. Please try again.");
    }
  }

  /// ✅ Cancel a facility booking
  Future<void> cancelBooking(String facilityId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await _firestore.collection("facilities").doc(facilityId).update({
        "availability": true,
        "bookedBy": FieldValue.delete(), // ✅ Fix: Properly removes `bookedBy`
      });
      print("✅ Booking canceled successfully: $facilityId");
    } catch (e) {
      print("❌ Error canceling booking: $e");
      throw Exception("Failed to cancel booking. Please try again.");
    }
  }
}
