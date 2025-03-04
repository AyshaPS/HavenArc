import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SentimentAnalysisScreen extends StatefulWidget {
  const SentimentAnalysisScreen({super.key});

  @override
  _SentimentAnalysisScreenState createState() =>
      _SentimentAnalysisScreenState();
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _sentimentResult = "Submit feedback to analyze sentiment";
  bool _isLoading = false;

  Future<void> _analyzeSentiment(String feedback) async {
    const String apiKey = "YOUR_SENTIMENT_API_KEY";
    const String endpoint = "https://api.text-processing.com/sentiment/";

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"text": feedback}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _sentimentResult = "Sentiment: ${data["label"].toString()}";
        });
      } else {
        setState(() {
          _sentimentResult = "Error analyzing sentiment";
        });
      }
    } catch (e) {
      setState(() {
        _sentimentResult = "Error: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sentiment Analysis"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select feedback to analyze sentiment:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("feedback")
                    .where("userId", isEqualTo: _auth.currentUser?.uid)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No feedback available."));
                  }

                  var feedbackList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      var feedback = feedbackList[index];

                      return Card(
                        child: ListTile(
                          title: Text(feedback["feedback"]),
                          onTap: () => _analyzeSentiment(feedback["feedback"]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _sentimentResult,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
    );
  }
}
