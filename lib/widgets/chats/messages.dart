import 'package:chat_app/widgets/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser.uid;
    return FutureBuilder(
      // future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (ctx, futureSnap) {
        /*  FutureSnap will return null because we don't have any Future data which is returned in future of Future Builder */
        if (futureSnap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final snapDocs = streamSnapshot.data.docs;

              return ListView.builder(
                reverse: true,
                itemCount: snapDocs.length,
                itemBuilder: (ctx, index) => BubbleMessage(
                  message: snapDocs[index]['text'],
                  isMe: snapDocs[index]['userId'] == userId,
                  key: ValueKey(snapDocs[index].id),
                  userName: snapDocs[index]['username'],
                  imageUrl: snapDocs[index]['imageUrl'],
                ),
              );
            });
      },
    );
  }
}
