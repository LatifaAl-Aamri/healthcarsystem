// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
//
// class ChatPage extends StatefulWidget {
//   final Map doctor;
//
//   const ChatPage({Key? key, required this.doctor}) : super(key: key);
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   late DatabaseReference _chatRef;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize a chat room using the doctor's key
//     _chatRef = FirebaseDatabase.instance.ref("chats/${widget.doctor['key']}");
//   }
//
//   void _sendMessage() {
//     final messageText = _messageController.text.trim();
//     if (messageText.isNotEmpty) {
//       _chatRef.push().set({
//         "message": messageText,
//         "timestamp": DateTime.now().millisecondsSinceEpoch,
//         "sender": "patient",
//       });
//       _messageController.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(" ${widget.doctor['dname']}"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           // Chat messages list from Firebase
//           Expanded(
//             child: FirebaseAnimatedList(
//               query: _chatRef,
//               itemBuilder: (context, snapshot, animation, index) {
//                 Map chat = snapshot.value as Map;
//                 return ListTile(
//                   title: Text(chat['message'] ?? ""),
//                   subtitle: Text(
//                     chat['sender'] ?? "",
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Message input field with send button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Type your message...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blueAccent),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.blue[50],
//     );
//   }
// }
