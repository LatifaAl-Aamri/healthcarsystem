import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatDoctorPage extends StatefulWidget {
  final Map doctor;

  const ChatDoctorPage({Key? key, required this.doctor}) : super(key: key);

  @override
  _ChatDoctorPageState createState() => _ChatDoctorPageState();
}

class _ChatDoctorPageState extends State<ChatDoctorPage> {
  final TextEditingController _messageController = TextEditingController();
  late DatabaseReference _chatRef;
  String? patientUsername;

  @override
  void initState() {
    super.initState();
    _loadUsernameAndInitChat();
  }

  // Load patient username from SharedPreferences and set up chat reference
  Future<void> _loadUsernameAndInitChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    patientUsername = prefs.getString('patientUsername') ?? 'anonymous';

    // Create a unique chat path: chats/doctorKey/patientUsername/
    _chatRef = FirebaseDatabase.instance
        .ref("chats/${widget.doctor['key']}/$patientUsername");

    setState(() {}); // trigger rebuild once initialized
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty && patientUsername != null) {
      _chatRef.push().set({
        "message": messageText,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "sender": patientUsername, // ✅ Send actual patient username
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (patientUsername == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.doctor['dname']}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: _chatRef,
              itemBuilder: (context, snapshot, animation, index) {
                Map chat = snapshot.value as Map;
                return ListTile(
                  title: Text(chat['message'] ?? ""),
                  subtitle: Text(
                    chat['sender'] ?? "",
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}
