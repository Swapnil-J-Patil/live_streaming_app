
import 'package:flutter/cupertino.dart';

class TextPost extends StatelessWidget {
  final String text;
  const TextPost({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      //23:13
      child: Text(text),
    );
  }
}

