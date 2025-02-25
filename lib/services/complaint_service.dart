import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitComplaint(String title, String description) async {
    try {
      String userId = _auth.currentUser!.uid;
      DocumentReference docRef = _firestore.collection('complaints').doc();

      Complaint complaint = Complaint(
        id: docRef.id, // Set the Firestore document ID
        userId: userId,
        title: title,
        description: description,
        status: 'Pending',
        timestamp: DateTime.now(),
      );

      await docRef.set(
          complaint.toMap()); // Use docRef.set() to include the document ID
    } catch (e) {
      throw Exception('Failed to submit complaint: $e');
    }
  }

  Stream<List<Complaint>> getUserComplaints() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Complaint.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Complaint>> getAllComplaints() {
    return _firestore.collection('complaints').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Complaint.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateComplaintStatus(String complaintId, String status) async {
    try {
      await _firestore
          .collection('complaints')
          .doc(complaintId)
          .update({'status': status});
    } catch (e) {
      throw Exception('Failed to update complaint status: $e');
    }
  }
}
