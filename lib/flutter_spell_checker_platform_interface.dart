import 'package:flutter_spell_checker/models/word_match.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_spell_checker_method_channel.dart';

abstract class FlutterSpellCheckerPlatform extends PlatformInterface {
  /// Constructs a FlutterSpellCheckerPlatform.
  FlutterSpellCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSpellCheckerPlatform _instance =
      MethodChannelFlutterSpellChecker();

  /// The default instance of [FlutterSpellCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSpellChecker].
  static FlutterSpellCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSpellCheckerPlatform] when
  /// they register themselves.
  static set instance(FlutterSpellCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<WordMatch>> checkSpelling(String text) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
