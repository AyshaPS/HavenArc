import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacilityDetailsScreen extends StatelessWidget {
  final String facilityId;
  const FacilityDetailsScreen({Key? key, required this.facilityId})
      : super(key: key);

  void bookFacility(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("facilities")
          .doc(facilityId)
          .update({
        "availability": false,
        "bookedBy": user.uid,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Facility booked successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facility Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("facilities")
            .doc(facilityId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          var facility = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(facility["name"],
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    "Status: ${facility["availability"] ? "Available" : "Booked"}",
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                if (facility["availability"])
                  ElevatedButton(
                    onPressed: () => bookFacility(context),
                    child: Text("Book Facility"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
