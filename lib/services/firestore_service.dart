import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Generic method to add data to a Firestore collection
  Future<void> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).add(data);
    } catch (e) {
      print("Error adding document: $e");
      rethrow;
    }
  }

  // Generic method to update a document in Firestore
  Future<void> updateDocument(
      String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      print("Error updating document: $e");
      rethrow;
    }
  }

  // Generic method to delete a document in Firestore
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _db.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      print("Error deleting document: $e");
      rethrow;
    }
  }

  // Generic method to fetch all documents from a collection
  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }

  // Generic method to fetch a single document by ID
  Future<DocumentSnapshot> getDocumentById(
      String collectionPath, String docId) async {
    return await _db.collection(collectionPath).doc(docId).get();
  }
}
