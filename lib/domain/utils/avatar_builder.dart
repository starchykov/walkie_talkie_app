import 'package:flutter/material.dart';

class AvatarBuilder {
  AvatarBuilder._internal();
  static final AvatarBuilder instance = AvatarBuilder._internal();

  final Map<String, Color> colorData = const {
    'A': Color.fromRGBO(203, 135, 153, 1.0),
    'B': Color.fromRGBO(245, 95, 145, 1.0),
    'C': Color.fromRGBO(179, 107, 193, 1.0),
    'D': Color.fromRGBO(153, 121, 206, 1.0),
    'E': Color.fromRGBO(113, 125, 205, 1.0),
    'F': Color.fromRGBO(84, 141, 243, 1.0),
    'G': Color.fromRGBO(59, 149, 191, 1.0),
    'H': Color.fromRGBO(94, 214, 217, 1.0),
    'I': Color.fromRGBO(105, 187, 180, 1.0),
    'J': Color.fromRGBO(112, 184, 149, 1.0),
    'K': Color.fromRGBO(143, 189, 96, 1.0),
    'L': Color.fromRGBO(182, 203, 0, 1.0),
    'M': Color.fromRGBO(246, 210, 8, 1.0),
    'N': Color.fromRGBO(232, 190, 23, 1.0),
    'O': Color.fromRGBO(241, 160, 3, 1.0),
    'P': Color.fromRGBO(255, 114, 63, 1.0),
    'Q': Color.fromRGBO(203, 202, 202, 1.0),
    'R': Color.fromRGBO(139, 163, 175, 1.0),
    'S': Color.fromRGBO(191, 165, 118, 1.0),
    'T': Color.fromRGBO(165, 161, 161, 1.0),
    'U': Color.fromRGBO(165, 172, 224, 1.0),
    'V': Color.fromRGBO(167, 146, 205, 1.0),
    'W': Color.fromRGBO(175, 174, 174, 1.0),
    'X': Color.fromRGBO(141, 210, 219, 1.0),
    'Y': Color.fromRGBO(191, 149, 136, 1.0),
    'Z': Color.fromRGBO(130, 172, 110, 1.0),
    '0': Color.fromRGBO(199, 199, 199, 1.0),
    '1': Color.fromRGBO(203, 135, 153, 1.0),
    '2': Color.fromRGBO(245, 95, 145, 1.0),
    '3': Color.fromRGBO(179, 107, 193, 1.0),
    '4': Color.fromRGBO(153, 121, 206, 1.0),
    '5': Color.fromRGBO(113, 125, 205, 1.0),
    '6': Color.fromRGBO(84, 141, 243, 1.0),
    '7': Color.fromRGBO(59, 149, 191, 1.0),
    '8': Color.fromRGBO(94, 214, 217, 1.0),
    '9': Color.fromRGBO(105, 187, 180, 1.0),
  };

  /// First two letters of the first and last name specified in the profile
  String makeInitials(String string, {int? limitTo}) {
    StringBuffer? buffer = StringBuffer();

    /// Return if string is empty
    if (string.isEmpty) return string;

    List<String> wordList = string.trim().split(' ');

    // Take first character if string is a single word
    if (wordList.length <= 1) return string.characters.first.toUpperCase();

    /// Fallback to actual word count if expected word count is greater
    if (limitTo != null && limitTo > wordList.length) {
      for (var i = 0; i < wordList.length; i++) {
        buffer.write(wordList[i][0]);
      }
      return buffer.toString().toUpperCase();
    }

    // Handle all other cases
    for (var i = 0; i < (limitTo ?? wordList.length); i++) {
      if (wordList[i].isNotEmpty)  buffer.write(wordList[i][0]);
    }
    return buffer.toString().toUpperCase();
  }

  /// Returned avatar background [Color] according to first string character.
  /// If [value] param is empty, [colorData][0] value will be returned as default.
  Color backgroundColor({required String? value}) {
    if (value == null) return colorData['0']!;
    if (value.trim().isEmpty) return colorData['0']!;
    if (value.trim().length < 0) return colorData[0]!;
    Color color = colorData[value.trim()[0].toUpperCase()] ?? colorData['0']!;
    return color;
  }

}
