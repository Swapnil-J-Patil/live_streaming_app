import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_streaming_app/views/auth/login.dart';
import 'package:live_streaming_app/views/auth/signup.dart';
import 'package:live_streaming_app/views/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Streaming App',
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily ,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: FirebaseAuth.instance.currentUser == null ?
      const Login() :
      const HomePage(),
    );
  }
}

