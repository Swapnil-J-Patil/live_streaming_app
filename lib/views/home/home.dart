import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming_app/views/auth/login.dart';
import 'package:live_streaming_app/views/home/search.dart';
import 'package:live_streaming_app/views/utils/TextPost.dart';
import 'package:live_streaming_app/views/utils/image_post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController postText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
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
                await FirebaseAuth.instance.signOut();
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

*/
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: postText,
                    decoration: const InputDecoration(
                      labelText: "Post something",
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (postText.text.trim().isEmpty) return;

                          await FirebaseFirestore.instance
                              .collection('posts')
                              .add({
                            'time': FieldValue.serverTimestamp(),
                            'type': 'text',
                            'content': postText.text.trim(),
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                          });

                          postText.clear();
                        },
                        child: const Text("Post"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No posts yet!"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      switch (data['type']) {
                        case 'text':
                          return TextPost(text: data['content']);
                        case 'image':
                          return ImagePost(
                            text: data['content'],
                            url: data['url'],
                          );
                        default:
                          return TextPost(text: data['content']);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
