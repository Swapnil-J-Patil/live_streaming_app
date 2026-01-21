import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String? email;
  String? password;
  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [

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
                labelText: "Password",),
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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email!,
                      password: password!,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (!mounted) return;

                    if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("The password provided is wrong.")),
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