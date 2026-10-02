import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

/// Declares two golden tests for [markdown] rendered by a default
/// [GptMarkdown]: `defaults/<name>_light.png` and `defaults/<name>_dark.png`,
/// next to the calling test file.
///
/// Text in goldens is drawn as solid blocks, so the images match on every
/// platform; `test/flutter_test_config.dart` explains and enforces it.
/// Generate or refresh them on any machine with
/// `flutter test test/golden --update-goldens`, and review the images before
/// committing: a golden that changed is a default that moved.
void markdownGolden(
  String name,
  String markdown, {
  Size size = const Size(420, 460),
}) {
  for (final brightness in Brightness.values) {
    testWidgets('$name ${brightness.name}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: brightness,
            extensions: [GptMarkdownThemeData(brightness: brightness)],
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: GptMarkdown(markdown),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      while (tester.takeException() != null) {}

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('defaults/${name}_${brightness.name}.png'),
      );
    }, skip: _skipGoldens);
  }
}

/// GPT_MARKDOWN_SKIP_GOLDENS opts out on an SDK the goldens were not
/// generated with. The beta-channel job in score.yml is the case that
/// matters: it exists to surface new lints and deprecations early, and engine
/// drift in how a shape is painted would bury that signal.
final _skipGoldens = Platform.environment.containsKey(
  'GPT_MARKDOWN_SKIP_GOLDENS',
);
