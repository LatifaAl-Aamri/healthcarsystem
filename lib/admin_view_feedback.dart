import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AdminViewFeedback extends StatefulWidget {
  const AdminViewFeedback({Key? key}) : super(key: key);

  @override
  _AdminViewFeedbackState createState() => _AdminViewFeedbackState();
}

class _AdminViewFeedbackState extends State<AdminViewFeedback> {
  final DatabaseReference _feedbackRef = FirebaseDatabase.instance.ref().child('feedback');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Feedback"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF0F4F8),
        child: StreamBuilder(
          stream: _feedbackRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(child: Text("No feedback available."));
            }

            Map feedbackMap = snapshot.data!.snapshot.value as Map;
            List feedbackList = feedbackMap.entries.toList().reversed.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                var entry = feedbackList[index].value;

                String opinion = entry['overallOpinion'] ?? 'No opinion';
                double rating = (entry['overallRating'] ?? 0).toDouble();
                int timestamp = entry['timestamp'] ?? 0;

                String formattedTime = DateFormat('yyyy-MM-dd • hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(timestamp),
                );

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: Opinion/Suggestion
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5F718A), // Dark navy blue
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.comment, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                opinion,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Section 2: Rating
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Colors.white,
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              "$rating / 5.0",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Section 3: Timestamp
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
