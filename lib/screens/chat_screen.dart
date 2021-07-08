import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              if (val == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            Container(
              child: NewMessages(),
            )
          ],
        ),
      ),
    );
  }
}
