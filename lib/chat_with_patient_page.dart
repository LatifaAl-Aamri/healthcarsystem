import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChatWithPatientPage extends StatefulWidget {
  final String doctorKey;
  final String patientUsername;
  const ChatWithPatientPage({Key? key, required this.doctorKey, required this.patientUsername, required String doctorUsername}) : super(key: key);

  @override
  _ChatWithPatientPageState createState() => _ChatWithPatientPageState();
}

class _ChatWithPatientPageState extends State<ChatWithPatientPage> {
  final TextEditingController _messageController = TextEditingController();
  late DatabaseReference _chatRef;
  // Optionally, load the doctor’s username from SharedPreferences or pass it along.
  String doctorUsername = 'Dr. Default';

  @override
  void initState() {
    super.initState();
    // Create the chat node reference using both doctorKey and patientUsername
    _chatRef = FirebaseDatabase.instance.ref('chats/${widget.doctorKey}/${widget.patientUsername}');
  }

  void _sendMessage() {
    final msg = _messageController.text.trim();
    if (msg.isNotEmpty) {
      _chatRef.push().set({
        'message': msg,
        'sender': doctorUsername,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.patientUsername}"),
      ),
      body: Column(
        children: [
          // Display chat messages
          Expanded(
            child: FirebaseAnimatedList(
              query: _chatRef,
              itemBuilder: (context, snapshot, animation, index) {
                Map chat = snapshot.value as Map;
                return ListTile(
                  title: Text(chat['message'] ?? ''),
                  subtitle: Text(chat['sender'] ?? ''),
                );
              },
            ),
          ),
          // Message input field
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
