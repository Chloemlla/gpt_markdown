import 'package:flutter/material.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown_chloemlla/gpt_markdown_chloemlla.dart';
import 'css_parser.dart';

/// HTML tag component with CSS style support
class HtmlTagMd extends InlineMd {
  @override
  RegExp get exp => RegExp(
    r'<(span|div|p|strong|em|i|b|u|s|mark)(?:\s+style="([^"]*)")?>(.*?)</\1>',
    dotAll: true,
  );

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    final GptMarkdownConfig config,
  ) {
    final match = exp.firstMatch(text.trim());
    if (match == null) return const TextSpan();

    final tagName = match.group(1) ?? '';
    final styleAttr = match.group(2) ?? '';
    final content = match.group(3) ?? '';

    // Parse CSS style
    TextStyle? parsedStyle = CssParser.parseInlineStyle(
      styleAttr,
      baseStyle: config.style,
    );

    // Apply tag-specific styles
    parsedStyle = _applyTagStyle(tagName, parsedStyle ?? config.style);

    final conf = config.copyWith(style: parsedStyle);

    return TextSpan(
      children: MarkdownComponent.generate(context, content, conf, false),
      style: parsedStyle,
    );
  }

  /// Apply default styles based on HTML tag
  TextStyle? _applyTagStyle(String tagName, TextStyle? baseStyle) {
    switch (tagName.toLowerCase()) {
      case 'strong':
      case 'b':
        return (baseStyle ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        );
      case 'em':
      case 'i':
        return (baseStyle ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        );
      case 'u':
        return (baseStyle ?? const TextStyle()).copyWith(
          decoration: TextDecoration.underline,
        );
      case 's':
        return (baseStyle ?? const TextStyle()).copyWith(
          decoration: TextDecoration.lineThrough,
        );
      case 'mark':
        return (baseStyle ?? const TextStyle()).copyWith(
          backgroundColor: const Color(0xFFFFFF00),
        );
      default:
        return baseStyle;
    }
  }
}
