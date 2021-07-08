import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  String _message = '';
  void _sendMessage() async {
    // Close Keyboard
    FocusScope.of(context).unfocus();
    // Get current user
    final userId = FirebaseAuth.instance.currentUser.uid;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    // Store data in Firestore
    FirebaseFirestore.instance.collection('chat').add({
      'createdAt': Timestamp.now(),
      'text': _message,
      'userId': userId,
      'username': userData['username'],
      'imageUrl': userData['image_url'],
    });
    _messageController.clear();
    _message = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: "Send a new Message..."),
              onChanged: (val) {
                setState(() {
                  _message = val;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _message.isEmpty
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColor,
            ),
            onPressed:
                (_message.isEmpty || _message == null) ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
