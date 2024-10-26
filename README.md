# flutter_spell_checker

`flutter_spell_checker` is a Flutter plugin that provides spell-checking functionality, using native libraries on both Android and iOS platforms to deliver accurate spelling suggestions based on device language settings. It's suitable for applications that require real-time or on-demand text validation, supporting multiple languages as configured on the user's device.

## Features

- Provides spelling suggestions based on the device's locale.
- Cross-platform support for Android and iOS.
- Simple API for integration into Flutter applications.

## Getting Started

### Installation

To add `flutter_spell_checker` to your project, include it in your `pubspec.yaml`:

```yaml
dependencies:
  flutter_spell_checker: ^1.0.0
```

### Usage

1. Import the package:
```Dart
import 'package:flutter_spell_checker/flutter_spell_checker.dart';
```

2. Use the checkSpelling method to check spelling and get replacements:
```Dart
final replacements = await FlutterSpellChecker.checkSpelling("Your txt here.");
print(replacements); // Outputs misspelled words with replacements
```

### Example
```Dart
void checkSpellingExample() async {
  final result = await FlutterSpellChecker.checkSpelling("Hello wrld");
  if (result.isNotEmpty) {
    print("Misspelled words and replacements:");
    for (var replacement in result) {
      print("${replacement.word}: ${replacement.replacements.join(', ')}");
    }
  } else {
    print("No misspellings found.");
  }
}
```

## Technical Details

- Android: Uses the SpellCheckerSession class from android.view.textservice, allowing native spell-checking on Android devices.
- iOS: Utilizes the UITextChecker class from the UIKit framework to provide native spell-checking on iOS.

## Limitations

- This plugin supports basic spell checking but does not provide grammar, style, or uppercase checks. This is due to limitations in the native Android and iOS SDKs, which do not natively support these advanced linguistic features.
- Word-by-Word Checking: This plugin currently checks each word individually rather than processing entire sentences.
- Language Limitations: Only supports languages configured in device settings; custom languages are not supported.
- Network Dependency: On Android, spell-check suggestions may vary by device and language.
- Compatibility: Requires Android 5.0+ and iOS 12.0+ for optimal functionality.

