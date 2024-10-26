import Flutter
import UIKit

public class FlutterSpellCheckerPlugin: NSObject, FlutterPlugin {
  private let textChecker = UITextChecker()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_spell_checker", binaryMessenger: registrar.messenger())
    let instance = FlutterSpellCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "checkSpelling" {
      if let args = call.arguments as? [String: Any],
        let text = args["text"] as? String
      {
        checkSpelling(text: text, result: result)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Text is required", details: nil))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func checkSpelling(text: String, result: @escaping FlutterResult) {
    let nsRange = NSRange(location: 0, length: text.utf16.count)
    var resultsArray: [[String: Any]] = []

    // Get the device’s preferred language (first item in the list of preferred languages)
    let language = Locale.preferredLanguages.first ?? "en_US"
    // Convert NSRange to Range<String.Index>
    if let range = Range(nsRange, in: text) {
      // Enumerate substrings (by words) in the range
      text.enumerateSubstrings(in: range, options: .byWords) { (substring, subrange, _, _) in
        if let word = substring {
          let wordRange = NSRange(subrange, in: text)
          let misspelledRange = self.textChecker.rangeOfMisspelledWord(
            in: text, range: wordRange, startingAt: 0, wrap: false, language: language)

          if misspelledRange.location != NSNotFound {
            let suggestions =
              self.textChecker.guesses(forWordRange: misspelledRange, in: text, language: language)
              ?? []
            let resultDict: [String: Any] = [
              "word": word,
              "suggestions": suggestions,
            ]
            resultsArray.append(resultDict)
          }
        }
      }
    }

    // Return results or indicate no misspelled words were found
    if resultsArray.isEmpty {
      result([])
    } else {
      result(resultsArray)
    }
  }
}
