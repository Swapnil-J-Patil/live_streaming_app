import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {

  final DocumentSnapshot doc;

  const ChatPage({super.key, required this.doc});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Page")),
      body: Column(
          children: [
            Expanded(child: StreamBuilder(stream: widget.doc.reference.collection('messages').snapshots(), builder: (context, snapshot)
            {
              if(snapshot.hasData)
                {
                  if(snapshot.data?.docs.isEmpty ?? true)
                    {
                      return Text("No Messages");
                    }
                  return Text("abdfjksld");
                }
              else
                {
                  return CircularProgressIndicator();
                }
            })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    decoration: InputDecoration(labelText: "Your Message",
                    ),
                    controller: message,),
                  ),

                  ElevatedButton(onPressed: () async {
                    widget.doc.reference.collection('messages').add({
                      'time' : DateTime.now(),
                      'uid' : FirebaseAuth.instance.currentUser!.uid,
                      'message' : message.text

                      //28:14
                    });
                  }, child: Text("Send"),)
                ],
              ),
            )
          ]
      ),
    );
  }
}
