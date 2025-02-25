import 'package:flutter/material.dart';
import '../models/voting_model.dart';
import '../services/voting_service.dart';

class VotingProvider with ChangeNotifier {
  final VotingService _votingService = VotingService();
  List<Voting> _votes = [];

  List<Voting> get votes => _votes;

  /// Fetch all votes from Firestore
  Future<void> fetchVotes() async {
    try {
      _votes = (await _votingService.getAllVotes().first)
          .cast<Voting>(); // Corrected fetching logic
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching votes: $e');
    }
  }

  /// Cast a vote
  Future<void> castVote(String voteId, String userId) async {
    try {
      await _votingService.castVote(voteId, userId); // Corrected function call
      await fetchVotes();
    } catch (e) {
      debugPrint('Error casting vote: $e');
    }
  }
}
