import 'package:FlutterChat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageBubble(
            chatDocs[i].get('text'),
            chatDocs[i].get('userName'),
            chatDocs[i].get('userId') == user.uid,
            key: ValueKey(chatDocs[i].documentID),
          ),
        );
      },
    );
  }
}
