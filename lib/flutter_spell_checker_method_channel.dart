import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spell_checker/models/word_match.dart';

import 'flutter_spell_checker_platform_interface.dart';

/// An implementation of [FlutterSpellCheckerPlatform] that uses method channels.
class MethodChannelFlutterSpellChecker extends FlutterSpellCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_spell_checker');

  @override
  Future<List<WordMatch>> checkSpelling(String text) async {
    final List<dynamic> suggestions =
        await methodChannel.invokeMethod('checkSpelling', {'text': text});

    return suggestions.map((e) {
      final result = Map<String, dynamic>.from(e);
      final word = result['word'] as String;
      final offset = text.indexOf(word) + 1;
      result['offset'] = offset;
      result['length'] = word.length;
      result['sentence'] = text;
      result['message'] = 'Possible spelling mistake found.';

      return WordMatch.fromJson(result);
    }).toList();
  }
}
