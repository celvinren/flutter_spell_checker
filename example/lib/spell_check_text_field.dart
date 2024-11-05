import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spell_checker/flutter_spell_checker.dart';
import 'package:flutter_spell_checker/models/word_match.dart';

class SpellCheckTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const SpellCheckTextField({
    Key? key,
    required this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  _SpellCheckTextFieldState createState() => _SpellCheckTextFieldState();
}

class _SpellCheckTextFieldState extends State<SpellCheckTextField> {
  List<WordMatch> mistakes = [];
  bool isChecking = false;
  OverlayEntry? suggestionsOverlay;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() async {
    if (isChecking || widget.controller.text.isEmpty) return;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1500), () async {
      isChecking = true;
      debugPrint("Checking spelling...${widget.controller.text}");

      final result =
          await FlutterSpellChecker.checkSpelling(widget.controller.text);
      setState(() {
        mistakes = result;
        isChecking = false;
      });

      //  .then((result) {
      //     setState(() {
      //       mistakes = result;
      //       isChecking = false;
      //     });
      //   }).catchError((_) {
      //     setState(() {
      //       isChecking = false;
      //     });
      //   });
    });
  }

  void _showSuggestionsOverlay(
      BuildContext context, WordMatch wordMatch, Offset offset) {
    if (suggestionsOverlay != null) {
      suggestionsOverlay!.remove();
    }

    final overlay = Overlay.of(context);
    suggestionsOverlay = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: wordMatch.replacements.map((suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    _replaceWord(wordMatch, suggestion);
                    suggestionsOverlay!.remove();
                    suggestionsOverlay = null;
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    overlay.insert(suggestionsOverlay!);
  }

  void _replaceWord(WordMatch wordMatch, String replacement) {
    final text = widget.controller.text;
    widget.controller.text = text.replaceRange(
      wordMatch.offset,
      wordMatch.offset + wordMatch.length,
      replacement,
    );
    widget.controller.selection =
        TextSelection.collapsed(offset: wordMatch.offset + replacement.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (details) {
            final position = details.localPosition;
            for (var mistake in mistakes) {
              final wordRect = _getWordRect(mistake);
              if (wordRect != null && wordRect.contains(position)) {
                _showSuggestionsOverlay(context, mistake, position);
                break;
              }
            }
          },
          child: Stack(
            children: [
              TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                decoration: const InputDecoration(
                  hintText: "Enter text...",
                ),
                style: const TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              if (mistakes.isNotEmpty) ..._buildMistakeHighlights(),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: mistakes.length,
          itemBuilder: (context, index) {
            final mistake = mistakes[index];
            return ListTile(
              title: Text(mistake.word),
              subtitle: Text(mistake.replacements.join(", ")),
              onTap: () {
                final overlayPosition = _getOverlayPositionForWord(mistake);
                _showSuggestionsOverlay(context, mistake, overlayPosition);
              },
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildMistakeHighlights() {
    final List<InlineSpan> spans = [];
    int lastIndex = 0;

    for (var mistake in mistakes) {
      // Ensure offset and offset + length are within bounds
      final mistakeEnd = mistake.offset + mistake.length;
      if (mistake.offset < 0 || mistakeEnd > widget.controller.text.length) {
        continue; // Skip if the indices are invalid
      }

      if (mistake.offset >= lastIndex) {
        // Add text before the mistake as a normal span
        spans.add(
          TextSpan(
            text: widget.controller.text.substring(lastIndex, mistake.offset),
          ),
        );

        // Add the misspelled word with red underline
        spans.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                final overlayPosition = _getOverlayPositionForWord(mistake);
                _showSuggestionsOverlay(context, mistake, overlayPosition);
              },
              child: Text(
                mistake.word,
                style: const TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.wavy,
                ),
              ),
            ),
          ),
        );

        lastIndex = mistakeEnd;
      }
    }

    // Add any remaining text after the last mistake
    if (lastIndex < widget.controller.text.length) {
      spans.add(
        TextSpan(
          text: widget.controller.text.substring(lastIndex),
        ),
      );
    }

    return [
      Positioned.fill(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16,
              color: Colors.transparent, // Aligns with TextField text color
            ),
            children: spans,
          ),
        ),
      ),
    ];
  }

  Offset _getOverlayPositionForWord(WordMatch wordMatch) {
    // Placeholder; replace with accurate calculation for your layout
    return const Offset(50, 50);
  }

  Rect? _getWordRect(WordMatch wordMatch) {
    // Placeholder; implement accurate calculations for word positioning
    return null;
  }
}
