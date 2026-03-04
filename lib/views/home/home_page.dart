import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming_app/views/auth/login.dart';
import 'package:live_streaming_app/views/home/chat.dart';
import 'package:live_streaming_app/views/home/home.dart';
import 'package:live_streaming_app/views/home/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
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
      ),*/

      bottomNavigationBar: BottomNavigationBar(
        onTap: (i){
          setState(() {
            index = i;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Live"),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: [
          Home(),
          ChatList(),
          Container()
        ],
      )
    );
  }
}
