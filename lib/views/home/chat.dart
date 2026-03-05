import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming_app/views/home/chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Chats")),
      body: FutureBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty ?? true) {
              return Text("No Chats !");
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(doc: doc),
                      ),
                    );
                  },
                  title: Text("Username"),
                  subtitle: Text(doc['recent_text']),
                  trailing: Icon(Icons.arrow_forward),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        future: FirebaseFirestore.instance
            .collection('chats')
            .where(
              'users',
              arrayContains: FirebaseAuth.instance.currentUser!.uid,
            )
            .get(),
      ),
    );
  }
}
