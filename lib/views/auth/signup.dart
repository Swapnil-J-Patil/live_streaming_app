import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../home/home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? username;
  String? email;
  String? password;
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
              validator: ValidationBuilder().maxLength(10).build(),
              onChanged: (value) {
                username = value;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
              validator: ValidationBuilder().email().maxLength(50).build(),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              validator: ValidationBuilder().minLength(6).maxLength(15).build(),
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(height: 12.0),

            ElevatedButton(
              onPressed: () async {
                if (key.currentState?.validate() ?? false) {
                  try {
                    UserCredential userCred = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );

                    if (userCred.user != null) {
                      var data = {
                          "username": username,
                          "email": email,
                          "created_at": DateTime.now().toIso8601String(),
                      };
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(userCred.user!.uid)
                          .set(data);
                    }
                    if (mounted) //To check if the widget is still visible or not
                    {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (!mounted) return;

                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("The password provided is too weak."),
                        ),
                      );
                    } else if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "The account already exists for that email.",
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? "Signup failed")),
                      );
                    }
                  }
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
