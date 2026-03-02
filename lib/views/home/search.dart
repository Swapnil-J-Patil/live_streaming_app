import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search for a user")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Username",
              ),
              onChanged: (val) {
                username = val;
                setState(() {});
              },
            ),
          ),
          if (username != null)
            if (username!.length > 3)
              FutureBuilder(
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    if (snapShot.data?.docs.isEmpty ?? false) {
                      return const Text("No user found");
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapShot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapShot.data!.docs[index];
                          return ListTile(
                            leading: IconButton(
                              onPressed: () async {
                                QuerySnapshot q = await FirebaseFirestore
                                    .instance
                                    .collection('chats')
                                    .where(
                                      'users',
                                      arrayContains: [FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid,
                                        doc.id
                                  ],
                                    )
                                    .get();
                                if(q.docs.isEmpty)
                                  {
                                    print("No doc");
                                    var data = {
                                      'users' : [
                                        FirebaseAuth.instance.currentUser!.uid,
                                        doc.id
                                      ],
                                      'recent_text' : "Hi"
                                    };
                                    await FirebaseFirestore
                                        .instance
                                        .collection('chats').add(data);
                                  }
                                else
                                  {
                                    print("Doc found");

                                  }
                              },
                              icon: Icon(Icons.chat, color: Colors.indigo),
                            ),
                            title: Text(doc["username"]),
                            trailing: FutureBuilder<DocumentSnapshot>(
                              future: doc.reference
                                  .collection("followers")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }

                                if (snapshot.hasData && snapshot.data!.exists) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      await doc.reference
                                          .collection('followers')
                                          .doc(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          )
                                          .delete();
                                      setState(() {});
                                    },
                                    child: const Text("Unfollow"),
                                  );
                                }

                                return ElevatedButton(
                                  onPressed: () async {
                                    await doc.reference
                                        .collection('followers')
                                        .doc(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        )
                                        .set({'time': DateTime.now()});
                                    setState(() {});
                                  },
                                  child: const Text("Follow"),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("username", isEqualTo: username)
                    .get(),
              ),
        ],
      ),
    );
  }
}
