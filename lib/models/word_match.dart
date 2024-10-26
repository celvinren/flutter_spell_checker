/// Object that stores information about matched mistakes.
class WordMatch {
  /// The word that was in the sentence.
  final String word;

  /// The message about the error.
  final String? message;

  /// The whole sentence.
  final String? sentence;

  /// Offset to the word.
  final int offset;

  /// Length of the word.
  final int length;

  /// List of possible replacements
  final List<String> replacements;

  /// Creates a new instance of the [WordMatch] class.
  WordMatch({
    required this.word,
    required this.offset,
    required this.length,
    this.message,
    this.sentence,
    this.replacements = const [],
  });

  /// Parse [WordMatch] from json.
  factory WordMatch.fromJson(Map<String, dynamic> map) {
    return WordMatch(
      word: map['word'],
      offset: map['offset'],
      length: map['length'],
      message: map['message'],
      sentence: map['sentence'],
      replacements: List<String>.from(map['suggestions']),
    );
  }
}
