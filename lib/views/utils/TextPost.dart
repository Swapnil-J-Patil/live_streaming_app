import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextPost extends StatelessWidget {
  final String text;

  const TextPost({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(text),
    );
  }
}
