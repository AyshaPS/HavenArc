import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VotingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Cast a vote for a specific poll
  Future<void> castVote(String voteId, String optionId) async {
    try {
      String userId = _auth.currentUser?.uid ?? "";
      if (userId.isEmpty) throw Exception("User not authenticated");

      DocumentReference pollRef = _firestore.collection('polls').doc(voteId);
      DocumentReference userVoteRef = pollRef.collection('votes').doc(userId);

      // Check if the user has already voted
      var existingVote = await userVoteRef.get();
      if (existingVote.exists) {
        throw Exception("User has already voted");
      }

      // Record the vote
      await userVoteRef.set({
        'userId': userId,
        'optionId': optionId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Increment the vote count for the selected option
      DocumentReference optionRef = pollRef.collection('options').doc(optionId);
      await optionRef.update({
        'votes': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception("Error casting vote: ${e.toString()}");
    }
  }

  /// Retrieve poll results
  Future<Map<String, int>> getPollResults(String pollId) async {
    try {
      DocumentReference pollRef = _firestore.collection('polls').doc(pollId);
      QuerySnapshot optionsSnapshot = await pollRef.collection('options').get();
      Map<String, int> results = {};

      for (var doc in optionsSnapshot.docs) {
        results[doc.id] = (doc['votes'] as int?) ?? 0;
      }
      return results;
    } catch (e) {
      throw Exception("Error retrieving poll results: ${e.toString()}");
    }
  }

  /// Get all votes stream
  Stream<List<Map<String, dynamic>>> getAllVotes() {
    return _firestore.collection('polls').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
