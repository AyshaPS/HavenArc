import 'package:flutter/material.dart';
import '../models/voting_model.dart';

class VotingCard extends StatelessWidget {
  final Voting voting;
  final VoidCallback onTap;

  const VotingCard({Key? key, required this.voting, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                voting.title.isNotEmpty ? voting.title : 'Untitled Voting',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Ends on: ${voting.endDate}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Votes: ${voting.totalVotes}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.how_to_vote, size: 24, color: Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
