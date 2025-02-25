import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotingResultsScreen extends StatelessWidget {
  const VotingResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting Results'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('votes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No votes have been cast yet.'));
          }

          // Process vote results
          Map<String, int> voteCounts = {};
          for (var doc in snapshot.data!.docs) {
            String candidate = doc['candidate'];
            voteCounts[candidate] = (voteCounts[candidate] ?? 0) + 1;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: voteCounts.entries.map((entry) {
              return Card(
                child: ListTile(
                  title: Text(entry.key,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  trailing: Text('${entry.value} votes',
                      style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
