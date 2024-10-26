import 'package:flutter/material.dart';
import 'package:flutter_spell_checker/flutter_spell_checker.dart';
import 'package:flutter_spell_checker/models/word_match.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Spell Checker Example'),
        ),
        body: const SpellCheckExample(),
      ),
    );
  }
}

class SpellCheckExample extends StatefulWidget {
  const SpellCheckExample({super.key});

  @override
  _SpellCheckExampleState createState() => _SpellCheckExampleState();
}

class _SpellCheckExampleState extends State<SpellCheckExample> {
  String _inputText = "Helo wrld";
  List<WordMatch> _suggestions = [];

  void _checkSpelling() async {
    final result = await FlutterSpellChecker.checkSpelling(_inputText);

    setState(() {
      _suggestions = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (text) {
              _inputText = text;
            },
            decoration: const InputDecoration(labelText: 'Enter text to check'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkSpelling,
            child: const Text('Check Spelling'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  title: Text('Word: ${suggestion.word}'),
                  subtitle: Text(
                      'Suggestions: ${suggestion.replacements.join(', ')}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
