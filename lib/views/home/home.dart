import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming_app/views/auth/login.dart';
import 'package:live_streaming_app/views/home/search.dart';
import 'package:live_streaming_app/views/utils/TextPost.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController postText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false,
                );
              },
              title: const Text("Sign Out"),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(

                    decoration: InputDecoration(labelText: "Post something"),
                    controller: postText,
                  ),
                  const SizedBox(height: 4.0,),
                  Row(
                    children: [
                      ElevatedButton(onPressed: () async {
                        var data = {
                          'time': DateTime.now(),
                          'type': 'text',
                          'content': postText.text,
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                        };

                        //9:12
                        FirebaseFirestore.instance.collection('posts').add(
                            data);
                        postText.text = "";
                        setState(() {

                        });
                      }, child: Text("Post")),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                  FirebaseAuth.instance.currentUser!.uid)
                  .collection('timeline')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return Text("No posts for you!");
                  }
                  else {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                              .collection('posts')
                              .doc((snapshot.data!.docs[index].data() as Map)!['post'])
                              .get(),
                            builder: (context, postSnapshot) {

                                if(postSnapshot.hasData)
                                  {
                                   switch (postSnapshot.data!['type'])
                                       {
                                     case 'text':
                                       return TextPost(text: postSnapshot.data!['content']);
                                     default:
                                       return TextPost(text: postSnapshot.data!['content']);

                                       }

                                  }
                                else
                                  {
                                    return CircularProgressIndicator();
                                  }
                            },
                          );
                        });
                  }
                }
                else {
                  return LinearProgressIndicator();
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
