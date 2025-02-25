import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visitor_model.dart';

class VisitorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream to get the list of visitors
  Stream<List<Visitor>> getUserVisitors() {
    return _firestore.collection('visitors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Visitor.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Register a new visitor
  Future<void> registerVisitor(Visitor visitor) async {
    try {
      await _firestore.collection('visitors').add(visitor.toMap());
    } catch (e) {
      throw Exception('Failed to register visitor: $e');
    }
  }

  /// Pre-approve a visitor for easier check-in
  Future<void> preApproveVisitor(Visitor visitor) async {
    try {
      await _firestore.collection('visitors').doc(visitor.id).update({
        'preApproved': true,
      });
    } catch (e) {
      throw Exception('Failed to pre-approve visitor: $e');
    }
  }

  /// Check-in visitor using QR Code
  Future<void> checkInWithQR(String qrCode) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('visitors')
          .where('qrCode', isEqualTo: qrCode)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'checkin_time': Timestamp.now(),
        });
      } else {
        throw Exception('QR Code not found in system.');
      }
    } catch (e) {
      throw Exception('QR Check-in failed: $e');
    }
  }

  /// Check-out visitor (New Feature)
  Future<void> checkOutVisitor(String visitorId) async {
    try {
      await _firestore.collection('visitors').doc(visitorId).update({
        'checkout_time': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to check out visitor: $e');
    }
  }

  /// Delete visitor record (Optional)
  Future<void> deleteVisitor(String visitorId) async {
    try {
      await _firestore.collection('visitors').doc(visitorId).delete();
    } catch (e) {
      throw Exception('Failed to delete visitor: $e');
    }
  }
}
