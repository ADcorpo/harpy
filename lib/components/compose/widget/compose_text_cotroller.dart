import 'package:flutter/material.dart';

/// A [TextEditingController] for the [ComposeScreen].
class ComposeTextController extends TextEditingController {
  ComposeTextController({
    String text,
    this.textStyleMap = const <RegExp, TextStyle>{},
  }) : super(text: text) {
    addListener(_listener);
  }

  /// Maps text styles to matches for the [RegExp].
  final Map<RegExp, TextStyle> textStyleMap;

  /// Callbacks that are mapped to a [RegExp] that will fire the callback with
  /// the selected word whenever the selected word matches the [RegExp].
  ///
  /// If the word does not match the [RegExp], the callback is invoked with
  /// `null`.
  ///
  /// A word is selected whenever the cursor is at the start, end, or in the
  /// middle of a word separated by whitespaces.
  final Map<RegExp, ValueChanged<String>> selectionRecognizers =
      <RegExp, ValueChanged<String>>{};

  /// A listener that will fire the [selectionRecognizers] if a selected word
  /// matches the regex.
  void _listener() {
    if (text.isNotEmpty &&
        selection.baseOffset >= 0 &&
        selection.baseOffset == selection.extentOffset) {
      final String start =
          text.substring(0, selection.baseOffset).split(RegExp(r'\s')).last;

      final String end =
          text.substring(selection.baseOffset).split(RegExp(r'\s')).first;

      final String word = '$start$end'.trim();

      for (MapEntry<RegExp, ValueChanged<String>> entry
          in selectionRecognizers.entries) {
        if (entry.key.hasMatch(word)) {
          entry.value(word);
        } else {
          entry.value(null);
        }
      }
    }
  }

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    final List<TextSpan> children = <TextSpan>[];

    text.splitMapJoin(
      RegExp(
        textStyleMap.keys.map((e) => e.pattern).join('|'),
        unicode: true,
        caseSensitive: false,
      ),
      onMatch: (Match match) {
        final RegExp regExp = textStyleMap.entries
            .singleWhere((MapEntry<RegExp, TextStyle> element) =>
                element.key.allMatches(match[0]).isNotEmpty)
            .key;

        children.add(
          TextSpan(
            text: match[0],
            style: textStyleMap[regExp],
          ),
        );

        return match[0];
      },
      onNonMatch: (String nonMatch) {
        children.add(TextSpan(text: nonMatch, style: style));
        return nonMatch;
      },
    );

    return TextSpan(style: style, children: children);
  }
}
