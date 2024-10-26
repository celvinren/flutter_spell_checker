import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_spell_checker_platform_interface.dart';

/// An implementation of [FlutterSpellCheckerPlatform] that uses method channels.
class MethodChannelFlutterSpellChecker extends FlutterSpellCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_spell_checker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
