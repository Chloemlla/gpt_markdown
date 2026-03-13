import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_markdown/css/css_parser.dart';

void main() {
  group('CssParser', () {
    group('parseInlineStyle', () {
      test('parses color in hex format', () {
        final style = CssParser.parseInlineStyle('color: #ff0000;');
        expect(style?.color, const Color(0xFFFF0000));
      });

      test('parses color in rgb format', () {
        final style = CssParser.parseInlineStyle('color: rgb(255, 0, 0);');
        expect(style?.color, const Color(0xFFFF0000));
      });

      test('parses color in rgba format', () {
        final style = CssParser.parseInlineStyle('color: rgba(255, 0, 0, 0.5);');
        expect(style?.color?.value, 0x80FF0000);
      });

      test('parses named color', () {
        final style = CssParser.parseInlineStyle('color: red;');
        expect(style?.color, const Color(0xFFFF0000));
      });

      test('parses font-size in px', () {
        final style = CssParser.parseInlineStyle('font-size: 20px;');
        expect(style?.fontSize, 20.0);
      });

      test('parses font-size in pt', () {
        final style = CssParser.parseInlineStyle('font-size: 12pt;');
        expect(style?.fontSize, closeTo(16.0, 0.1));
      });

      test('parses font-size in em', () {
        final style = CssParser.parseInlineStyle('font-size: 1.5em;');
        expect(style?.fontSize, 24.0);
      });

      test('parses font-weight bold', () {
        final style = CssParser.parseInlineStyle('font-weight: bold;');
        expect(style?.fontWeight, FontWeight.bold);
      });

      test('parses font-weight numeric', () {
        final style = CssParser.parseInlineStyle('font-weight: 700;');
        expect(style?.fontWeight, FontWeight.w700);
      });

      test('parses font-style italic', () {
        final style = CssParser.parseInlineStyle('font-style: italic;');
        expect(style?.fontStyle, FontStyle.italic);
      });

      test('parses text-decoration underline', () {
        final style = CssParser.parseInlineStyle('text-decoration: underline;');
        expect(style?.decoration, TextDecoration.underline);
      });

      test('parses text-decoration line-through', () {
        final style = CssParser.parseInlineStyle('text-decoration: line-through;');
        expect(style?.decoration, TextDecoration.lineThrough);
      });

      test('parses background-color', () {
        final style = CssParser.parseInlineStyle('background-color: yellow;');
        expect(style?.backgroundColor, const Color(0xFFFFFF00));
      });

      test('parses font-family', () {
        final style = CssParser.parseInlineStyle('font-family: "Arial";');
        expect(style?.fontFamily, 'Arial');
      });

      test('parses multiple properties', () {
        final style = CssParser.parseInlineStyle(
          'color: #ff0000; font-size: 20px; font-weight: bold;',
        );
        expect(style?.color, const Color(0xFFFF0000));
        expect(style?.fontSize, 20.0);
        expect(style?.fontWeight, FontWeight.bold);
      });

      test('returns baseStyle when cssString is empty', () {
        const baseStyle = TextStyle(color: Colors.blue);
        final style = CssParser.parseInlineStyle('', baseStyle: baseStyle);
        expect(style, baseStyle);
      });

      test('merges with baseStyle', () {
        const baseStyle = TextStyle(fontSize: 14.0);
        final style = CssParser.parseInlineStyle(
          'color: red;',
          baseStyle: baseStyle,
        );
        expect(style?.color, const Color(0xFFFF0000));
        expect(style?.fontSize, 14.0);
      });

      test('handles invalid CSS gracefully', () {
        final style = CssParser.parseInlineStyle('invalid css;;;');
        expect(style, isNotNull);
      });
    });

    group('Color parsing', () {
      test('parses 6-digit hex color', () {
        final style = CssParser.parseInlineStyle('color: #3498db;');
        expect(style?.color, const Color(0xFF3498DB));
      });

      test('parses 8-digit hex color with alpha', () {
        final style = CssParser.parseInlineStyle('color: #80FF0000;');
        expect(style?.color, const Color(0x80FF0000));
      });

      test('parses rgb with spaces', () {
        final style = CssParser.parseInlineStyle('color: rgb(100, 150, 200);');
        expect(style?.color, const Color(0xFF6496C8));
      });

      test('parses rgba with decimal alpha', () {
        final style = CssParser.parseInlineStyle('color: rgba(255, 0, 0, 0.75);');
        expect(style?.color?.value, 0xBFFF0000);
      });

      test('parses common named colors', () {
        expect(
          CssParser.parseInlineStyle('color: black;')?.color,
          const Color(0xFF000000),
        );
        expect(
          CssParser.parseInlineStyle('color: white;')?.color,
          const Color(0xFFFFFFFF),
        );
        expect(
          CssParser.parseInlineStyle('color: blue;')?.color,
          const Color(0xFF0000FF),
        );
        expect(
          CssParser.parseInlineStyle('color: green;')?.color,
          const Color(0xFF008000),
        );
      });
    });

    group('Font size parsing', () {
      test('parses various px values', () {
        expect(CssParser.parseInlineStyle('font-size: 10px;')?.fontSize, 10.0);
        expect(CssParser.parseInlineStyle('font-size: 24px;')?.fontSize, 24.0);
        expect(CssParser.parseInlineStyle('font-size: 100px;')?.fontSize, 100.0);
      });

      test('parses pt values', () {
        expect(
          CssParser.parseInlineStyle('font-size: 10pt;')?.fontSize,
          closeTo(13.33, 0.1),
        );
      });

      test('parses em values', () {
        expect(CssParser.parseInlineStyle('font-size: 1em;')?.fontSize, 16.0);
        expect(CssParser.parseInlineStyle('font-size: 2em;')?.fontSize, 32.0);
      });
    });

    group('Font weight parsing', () {
      test('parses all numeric weights', () {
        expect(
          CssParser.parseInlineStyle('font-weight: 100;')?.fontWeight,
          FontWeight.w100,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 200;')?.fontWeight,
          FontWeight.w200,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 300;')?.fontWeight,
          FontWeight.w300,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 400;')?.fontWeight,
          FontWeight.w400,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 500;')?.fontWeight,
          FontWeight.w500,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 600;')?.fontWeight,
          FontWeight.w600,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 700;')?.fontWeight,
          FontWeight.w700,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 800;')?.fontWeight,
          FontWeight.w800,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: 900;')?.fontWeight,
          FontWeight.w900,
        );
      });

      test('parses named weights', () {
        expect(
          CssParser.parseInlineStyle('font-weight: normal;')?.fontWeight,
          FontWeight.normal,
        );
        expect(
          CssParser.parseInlineStyle('font-weight: bold;')?.fontWeight,
          FontWeight.bold,
        );
      });
    });
  });
}
