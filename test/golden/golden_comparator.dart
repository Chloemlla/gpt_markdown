import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// The golden comparator for every test under `test/`, installed by
/// `test/flutter_test_config.dart`.
///
/// It adds two things to [LocalFileComparator]:
///
///  * **Text must be blocks.** A golden compared or written while a real font
///    is loaded fails. Glyph rasterisation is what differs between platforms;
///    with no font loaded, `flutter_test` draws every family in its built-in
///    `FlutterTest` font, where each character is a solid 1em block.
///  * **A per-pixel tolerance of [maxChannelDelta].** Every pixel must still
///    match, but each colour channel may be off by a few levels. The engine
///    sometimes antialiases a clipped rounded corner a shade differently from
///    run to run on the same machine (seen as 1–4 levels on the code panel).
///    A real change — a wider bar, another colour, moved padding — moves
///    pixels by tens of levels and still fails, however few pixels it touches.
///    That is why this is not a share-of-pixels tolerance: one of those, at
///    0.5%, let a blockquote bar widen from 3 to 9 points.
final class GoldenComparator extends LocalFileComparator {
  /// Compares against goldens next to [testFile].
  GoldenComparator(super.testFile);

  /// Largest difference allowed in any one channel (0–255) of any pixel.
  static const maxChannelDelta = 8;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    _expectBlockText(golden);
    if (await withinTolerance(imageBytes, await getGoldenBytes(golden))) {
      return true;
    }
    // Out of tolerance: the exact comparison fails too, and writes the usual
    // diff images to `failures/`.
    return super.compare(imageBytes, golden);
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    _expectBlockText(golden);
    return super.update(golden, imageBytes);
  }

  /// Whether the PNGs [a] and [b] have the same size and no channel of any
  /// pixel differs by more than [maxChannelDelta].
  static Future<bool> withinTolerance(List<int> a, List<int> b) async {
    final (aWidth, aHeight, aPixels) = await _decode(a);
    final (bWidth, bHeight, bPixels) = await _decode(b);
    if (aWidth != bWidth || aHeight != bHeight) return false;
    for (var i = 0; i < aPixels.length; i++) {
      if ((aPixels[i] - bPixels[i]).abs() > maxChannelDelta) return false;
    }
    return true;
  }
}

Future<(int, int, Uint8List)> _decode(List<int> png) async {
  final codec = await ui.instantiateImageCodec(Uint8List.fromList(png));
  final image = (await codec.getNextFrame()).image;
  codec.dispose();
  final data = await image.toByteData(
    format: ui.ImageByteFormat.rawStraightRgba,
  );
  final result = (image.width, image.height, data!.buffer.asUint8List());
  image.dispose();
  return result;
}

/// Families the package renders with. In `FlutterTest`, every character is
/// exactly 1em wide; a real font gives `i` and `M` other widths.
const _families = <(String?, String?)>[
  (null, null),
  ('JetBrainsMono', 'gpt_markdown'),
];

void _expectBlockText(Uri golden) {
  const fontSize = 10.0;
  for (final (family, package) in _families) {
    final painter = TextPainter(
      text: TextSpan(
        text: 'iM',
        style: TextStyle(
          fontFamily: family,
          package: package,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final width = painter.width;
    painter.dispose();
    if (width != 2 * fontSize) {
      throw StateError(
        'Golden "$golden" was rendered with a real font '
        '(${family ?? 'the default family'}). Goldens draw text as blocks so '
        'they match on every platform; see test/golden/golden_comparator.dart. '
        'Do not load fonts in a test that takes a golden.',
      );
    }
  }
}
