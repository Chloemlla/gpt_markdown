import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'css_stylesheet.dart';
import 'css_parser.dart';

/// CSS Theme manager for applying stylesheet-based themes
class CssTheme {
  final CssStylesheet _stylesheet;
  final Map<String, TextStyle> _styleCache = {};

  CssTheme._(this._stylesheet);

  /// Load CSS theme from asset file
  static Future<CssTheme> fromAsset(String assetPath) async {
    final cssContent = await rootBundle.loadString(assetPath);
    return fromString(cssContent);
  }

  /// Load CSS theme from string
  static CssTheme fromString(String cssContent) {
    final stylesheet = CssStylesheet.parse(cssContent);
    return CssTheme._(stylesheet);
  }

  /// Get TextStyle for a specific selector
  TextStyle? getTextStyle(String selector, {TextStyle? baseStyle}) {
    final cacheKey = '$selector:${baseStyle.hashCode}';
    if (_styleCache.containsKey(cacheKey)) {
      return _styleCache[cacheKey];
    }

    final properties = _stylesheet.getStylesForSelector(selector);
    if (properties.isEmpty) return baseStyle;

    final style = CssParser.parsePropertiesMap(properties, baseStyle: baseStyle);
    _styleCache[cacheKey] = style ?? baseStyle ?? const TextStyle();
    return style;
  }

  /// Get color from CSS variable
  Color? getColor(String variableName) {
    final value = _stylesheet.getCssVariable(variableName);
    if (value == null) return null;

    return _parseColor(value);
  }

  /// Get all CSS variables
  Map<String, String> getAllVariables() => _stylesheet.getAllVariables();

  /// Create a MarkdownTheme from this CSS theme
  MarkdownThemeData toMarkdownTheme({
    required BuildContext context,
    TextStyle? baseStyle,
  }) {
    final theme = Theme.of(context);
    baseStyle ??= theme.textTheme.bodyMedium;

    return MarkdownThemeData(
      h1Style: getTextStyle('.markdown-body h1', baseStyle: baseStyle),
      h2Style: getTextStyle('.markdown-body h2', baseStyle: baseStyle),
      h3Style: getTextStyle('.markdown-body h3', baseStyle: baseStyle),
      h4Style: getTextStyle('.markdown-body h4', baseStyle: baseStyle),
      h5Style: getTextStyle('.markdown-body h5', baseStyle: baseStyle),
      h6Style: getTextStyle('.markdown-body h6', baseStyle: baseStyle),
      pStyle: getTextStyle('.markdown-body p', baseStyle: baseStyle),
      codeStyle: getTextStyle('.markdown-body code', baseStyle: baseStyle),
      blockquoteStyle: getTextStyle('.markdown-body blockquote', baseStyle: baseStyle),
      linkStyle: getTextStyle('.markdown-body a', baseStyle: baseStyle),
      strongStyle: getTextStyle('.markdown-body strong', baseStyle: baseStyle),
      emStyle: getTextStyle('.markdown-body em', baseStyle: baseStyle),
      backgroundColor: getColor('--bgColor-default'),
      foregroundColor: getColor('--fgColor-default'),
      accentColor: getColor('--fgColor-accent'),
      borderColor: getColor('--borderColor-default'),
    );
  }

  Color? _parseColor(String colorString) {
    colorString = colorString.trim().toLowerCase();

    // Hex color
    if (colorString.startsWith('#')) {
      final hex = colorString.substring(1);
      if (hex.length == 3) {
        final r = hex[0] + hex[0];
        final g = hex[1] + hex[1];
        final b = hex[2] + hex[2];
        return Color(int.parse('FF$r$g$b', radix: 16));
      } else if (hex.length == 6) {
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

    return null;
  }
}

/// Markdown theme data extracted from CSS
class MarkdownThemeData {
  final TextStyle? h1Style;
  final TextStyle? h2Style;
  final TextStyle? h3Style;
  final TextStyle? h4Style;
  final TextStyle? h5Style;
  final TextStyle? h6Style;
  final TextStyle? pStyle;
  final TextStyle? codeStyle;
  final TextStyle? blockquoteStyle;
  final TextStyle? linkStyle;
  final TextStyle? strongStyle;
  final TextStyle? emStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? accentColor;
  final Color? borderColor;

  const MarkdownThemeData({
    this.h1Style,
    this.h2Style,
    this.h3Style,
    this.h4Style,
    this.h5Style,
    this.h6Style,
    this.pStyle,
    this.codeStyle,
    this.blockquoteStyle,
    this.linkStyle,
    this.strongStyle,
    this.emStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.accentColor,
    this.borderColor,
  });
}
