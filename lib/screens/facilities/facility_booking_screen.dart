import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:havenarc/models/facility_model.dart';
import 'package:havenarc/widgets/facility_card.dart';

class FacilityBookingScreen extends StatelessWidget {
  const FacilityBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Facility Booking")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("facilities").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint("❌ Firestore Error: \${snapshot.error}");
            return const Center(child: Text("Error loading facilities"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No facilities available"));
          }

          final facilities = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return FacilityModel.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              final facility = facilities[index];
              return FacilityCard(
                facility: facility,
                onTap: () => _showBookingDialog(context, facility),
              );
            },
          );
        },
      ),
    );
  }

  void _showBookingDialog(BuildContext context, FacilityModel facility) {
    if (facility.availableSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No available slots for this facility")),
      );
      return;
    }

    String selectedSlot = facility.availableSlots.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Book \${facility.name}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedSlot,
                    items: facility.availableSlots.map((slot) {
                      return DropdownMenuItem(
                        value: slot,
                        child: Text(slot),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSlot = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success =
                        await _bookFacility(context, facility.id, selectedSlot);
                    if (success) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _bookFacility(
      BuildContext context, String facilityId, String slot) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You must be logged in to book a facility.")),
      );
      return false;
    }

    try {
      await FirebaseFirestore.instance
          .collection('facilities')
          .doc(facilityId)
          .collection('bookings')
          .add({
        'user_id': user.uid,
        'slot': slot,
        'status': 'confirmed',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking successful!")),
      );
      return true;
    } catch (e) {
      debugPrint("❌ Error booking facility: \$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking failed. Please try again.")),
      );
      return false;
    }
  }
}
