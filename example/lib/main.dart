import 'package:flutter/material.dart';

import 'spell_check_text_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Spell Check Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpellCheckTextField(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
