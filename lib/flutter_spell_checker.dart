import 'package:flutter/foundation.dart';
import 'package:flutter_spell_checker/models/word_match.dart';

import 'flutter_spell_checker_platform_interface.dart';

class FlutterSpellChecker {
  static Future<List<WordMatch>> checkSpelling(String text) {
    if (kIsWeb) throw UnsupportedError('Web is not supported');
    return FlutterSpellCheckerPlatform.instance.checkSpelling(text);
  }
}
