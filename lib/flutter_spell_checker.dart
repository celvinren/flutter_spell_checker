import 'package:flutter_spell_checker/models/word_match.dart';

import 'flutter_spell_checker_platform_interface.dart';

class FlutterSpellChecker {
  static Future<List<WordMatch>> checkSpelling(String text) {
    return FlutterSpellCheckerPlatform.instance.checkSpelling(text);
  }
}
