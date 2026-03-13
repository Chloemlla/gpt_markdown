import 'package:flutter/material.dart';

/// CSS Parser for parsing inline styles and style attributes
class CssParser {
  /// Parse inline CSS style string to TextStyle
  static TextStyle? parseInlineStyle(String cssString, {TextStyle? baseStyle}) {
    if (cssString.isEmpty) return baseStyle;

    try {
      final properties = _parseProperties(cssString);
      return _buildTextStyle(properties, baseStyle);
    } catch (e) {
      return baseStyle;
    }
  }

  /// Parse CSS properties from inline style string
  static Map<String, String> _parseProperties(String cssString) {
    final properties = <String, String>{};

    // Split by semicolon and parse each property
    final declarations = cssString.split(';');

    for (final declaration in declarations) {
      final parts = declaration.split(':');
      if (parts.length == 2) {
        final property = parts[0].trim().toLowerCase();
        final value = parts[1].trim();
        properties[property] = value;
      }
    }

    return properties;
  }

  /// Build TextStyle from CSS properties
  static TextStyle? _buildTextStyle(
    Map<String, String> properties,
    TextStyle? baseStyle,
  ) {
    Color? color;
    Color? backgroundColor;
    double? fontSize;
    FontWeight? fontWeight;
    FontStyle? fontStyle;
    TextDecoration? decoration;
    String? fontFamily;

    // Parse color
    if (properties.containsKey('color')) {
      color = _parseColor(properties['color']!);
    }

    // Parse background-color
    if (properties.containsKey('background-color')) {
      backgroundColor = _parseColor(properties['background-color']!);
    }

    // Parse font-size
    if (properties.containsKey('font-size')) {
      fontSize = _parseFontSize(properties['font-size']!);
    }

    // Parse font-weight
    if (properties.containsKey('font-weight')) {
      fontWeight = _parseFontWeight(properties['font-weight']!);
    }

    // Parse font-style
    if (properties.containsKey('font-style')) {
      fontStyle = _parseFontStyle(properties['font-style']!);
    }

    // Parse text-decoration
    if (properties.containsKey('text-decoration')) {
      decoration = _parseTextDecoration(properties['text-decoration']!);
    }

    // Parse font-family
    if (properties.containsKey('font-family')) {
      fontFamily = properties['font-family']!.replaceAll('"', '').replaceAll("'", '');
    }

    return (baseStyle ?? const TextStyle()).copyWith(
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      fontFamily: fontFamily,
    );
  }

  /// Parse CSS color value
  static Color? _parseColor(String colorString) {
    colorString = colorString.trim().toLowerCase();

    // Hex color
    if (colorString.startsWith('#')) {
      final hex = colorString.substring(1);
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    // RGB/RGBA
    if (colorString.startsWith('rgb')) {
      final match = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)')
          .firstMatch(colorString);
      if (match != null) {
        final r = int.parse(match.group(1)!);
        final g = int.parse(match.group(2)!);
        final b = int.parse(match.group(3)!);
        final a = match.group(4) != null ? double.parse(match.group(4)!) : 1.0;
        return Color.fromRGBO(r, g, b, a);
      }
    }

    // Named colors
    return _namedColors[colorString];
  }

  /// Parse font size
  static double? _parseFontSize(String sizeString) {
    sizeString = sizeString.trim().toLowerCase();

    if (sizeString.endsWith('px')) {
      return double.tryParse(sizeString.replaceAll('px', ''));
    } else if (sizeString.endsWith('pt')) {
      final pt = double.tryParse(sizeString.replaceAll('pt', ''));
      return pt != null ? pt * 1.333 : null;
    } else if (sizeString.endsWith('em')) {
      final em = double.tryParse(sizeString.replaceAll('em', ''));
      return em != null ? em * 16 : null;
    }

    return double.tryParse(sizeString);
  }

  /// Parse font weight
  static FontWeight? _parseFontWeight(String weightString) {
    weightString = weightString.trim().toLowerCase();

    switch (weightString) {
      case 'normal':
        return FontWeight.normal;
      case 'bold':
        return FontWeight.bold;
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      default:
        return null;
    }
  }

  /// Parse font style
  static FontStyle? _parseFontStyle(String styleString) {
    styleString = styleString.trim().toLowerCase();

    switch (styleString) {
      case 'italic':
        return FontStyle.italic;
      case 'normal':
        return FontStyle.normal;
      default:
        return null;
    }
  }

  /// Parse text decoration
  static TextDecoration? _parseTextDecoration(String decorationString) {
    decorationString = decorationString.trim().toLowerCase();

    switch (decorationString) {
      case 'underline':
        return TextDecoration.underline;
      case 'line-through':
        return TextDecoration.lineThrough;
      case 'overline':
        return TextDecoration.overline;
      case 'none':
        return TextDecoration.none;
      default:
        return null;
    }
  }

  /// Named CSS colors
  static final Map<String, Color> _namedColors = {
    'black': const Color(0xFF000000),
    'white': const Color(0xFFFFFFFF),
    'red': const Color(0xFFFF0000),
    'green': const Color(0xFF008000),
    'blue': const Color(0xFF0000FF),
    'yellow': const Color(0xFFFFFF00),
    'cyan': const Color(0xFF00FFFF),
    'magenta': const Color(0xFFFF00FF),
    'gray': const Color(0xFF808080),
    'grey': const Color(0xFF808080),
    'orange': const Color(0xFFFFA500),
    'purple': const Color(0xFF800080),
    'pink': const Color(0xFFFFC0CB),
    'brown': const Color(0xFFA52A2A),
  };
}
