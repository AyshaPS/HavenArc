import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:havenarc/models/facility_model.dart';

class FacilityDetailsScreen extends StatefulWidget {
  final String apartmentId; // Apartment ID to fetch relevant facilities

  const FacilityDetailsScreen({super.key, required this.apartmentId});

  @override
  _FacilityDetailsScreenState createState() => _FacilityDetailsScreenState();
}

class _FacilityDetailsScreenState extends State<FacilityDetailsScreen> {
  late Stream<QuerySnapshot> facilityStream;

  @override
  void initState() {
    super.initState();
    facilityStream = FirebaseFirestore.instance
        .collection("facilities")
        .where("apartmentId",
            isEqualTo: widget.apartmentId) // Filter by Apartment
        .snapshots();
  }

  /// 🔹 Book a Facility
  Future<void> bookFacility(FacilityModel facility) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please log in to book a facility")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("facilities")
          .doc(facility.id)
          .update({
        "bookedBy": user.uid, // Store user ID
        "availability": false, // Mark as booked
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ ${facility.name} booked successfully!")),
      );
    } catch (e) {
      print("❌ Error booking facility: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Booking failed. Try again!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Facility Details")),
      body: StreamBuilder<QuerySnapshot>(
        stream: facilityStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("❌ Error loading facilities"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("📌 No facilities available"));
          }

          List<FacilityModel> facilities = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return FacilityModel.fromMap(
                data, doc.id); // ✅ Fixed data conversion
          }).toList();

          return ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              var facility = facilities[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(facility.name),
                  subtitle: Text(facility.location),
                  trailing: facility.bookedBy.isEmpty
                      ? ElevatedButton(
                          onPressed: () => bookFacility(facility),
                          child: const Text("Book Now"),
                        )
                      : Text(
                          "Booked by ${facility.bookedBy}",
                          style: const TextStyle(color: Colors.red),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
