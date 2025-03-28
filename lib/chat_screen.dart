import 'package:flutter/material.dart';
import 'chatbot_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isBotTyping = false;

  Future<void> _saveMessageToFirestore(String sender, String message) async {
    await FirebaseFirestore.instance.collection('chats').add({
      "sender": sender,
      "message": message,
      "time": FieldValue.serverTimestamp(),
    });
  }

  void _sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      isBotTyping = true;
    });

    _controller.clear();
    await _saveMessageToFirestore("user", userMessage);

    try {
      var response = await ChatbotService.sendMessage("user", userMessage);

      String botReply = response["response"] ?? "No response from chatbot";
      await _saveMessageToFirestore("bot", botReply);

      if (response["remedies"] != null && response["remedies"].isNotEmpty) {
        for (var remedy in response["remedies"]) {
          await _saveMessageToFirestore(
            "bot",
            "${remedy['name']}: ${remedy['remedy']}",
          );
        }
      }
    } catch (e) {
      await _saveMessageToFirestore("bot", "Error: Unable to connect to chatbot.");
      print("Chatbot API Error: $e");
    }

    setState(() {
      isBotTyping = false;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/chat_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildMessagesList()),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.8),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Center(
        child: Text(
          "HealthBot",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var chatDocs = snapshot.data!.docs;
        List<Map<String, dynamic>> messages = chatDocs.map((doc) {
          return {
            "sender": doc["sender"] ?? "",
            "message": doc["message"] ?? "",
            "time": (doc["time"] as Timestamp?)?.toDate() ?? DateTime.now(),
          };
        }).toList();

        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          itemCount: messages.length + (isBotTyping ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == messages.length && isBotTyping) {
              return _typingIndicator();
            }

            bool isUser = messages[index]["sender"] == "user";
            bool isRemedy = messages[index]["message"].contains(":");

            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: isRemedy
                    ? null // No background for remedies
                    : BoxDecoration(
                  color: isUser
                      ? Colors.lightBlueAccent.withOpacity(0.9)
                      : Colors.grey.withOpacity(0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
                    bottomRight: isUser ? Radius.zero : Radius.circular(16),
                  ),
                ),
                child: isRemedy
                    ? _buildRemedyBox(messages[index]["message"])
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messages[index]["message"],
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatTime(messages[index]["time"]),
                      style: TextStyle(
                        color: isUser ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(),
            SizedBox(width: 4),
            _dot(),
            SizedBox(width: 4),
            _dot(),
          ],
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildRemedyBox(String message) {
    List<String> parts = message.split(": ");
    String title = parts[0];
    String remedyText = parts.length > 1 ? parts[1] : "";

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            remedyText,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
