import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

//17:50
class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Chats")),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Text("data");
        },
        future: FirebaseFirestore.instance
            .collection('chats')
            .where(
              'users',
              arrayContains: [FirebaseAuth.instance.currentUser!.uid],
            )
            .get(),
      ),
    );
  }
}
