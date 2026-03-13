# CSS Support for GPT Markdown

This module adds CSS parsing support to gpt_markdown, allowing you to use inline CSS styles with HTML tags in your markdown content.

## Features

- Parse inline CSS styles (e.g., `style="color: red; font-size: 20px;"`)
- Support common HTML tags: `<span>`, `<div>`, `<p>`, `<strong>`, `<em>`, `<i>`, `<b>`, `<u>`, `<s>`, `<mark>`
- Support CSS properties:
  - `color` (hex, rgb, rgba, named colors)
  - `background-color`
  - `font-size` (px, pt, em)
  - `font-weight` (normal, bold, 100-900)
  - `font-style` (normal, italic)
  - `text-decoration` (underline, line-through, overline, none)
  - `font-family`

## Installation

Add `csslib` to your `pubspec.yaml`:

```yaml
dependencies:
  gpt_markdown: ^1.1.5
  csslib: ^1.0.0
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:gpt_markdown/css/css.dart';

GptMarkdown(
  '''
  <span style="color: red; font-size: 20px;">Red text</span>

  <strong style="color: blue;">Bold blue text</strong>
  ''',
  components: [
    ...MarkdownComponent.globalComponents,
    HtmlTagMd(),
  ],
  inlineComponents: [
    ...MarkdownComponent.inlineComponents,
    HtmlTagMd(),
  ],
)
```

### Supported CSS Properties

#### Color
```dart
<span style="color: #ff0000;">Hex color</span>
<span style="color: rgb(255, 0, 0);">RGB color</span>
<span style="color: rgba(255, 0, 0, 0.5);">RGBA color</span>
<span style="color: red;">Named color</span>
```

#### Font Size
```dart
<span style="font-size: 20px;">20 pixels</span>
<span style="font-size: 16pt;">16 points</span>
<span style="font-size: 1.5em;">1.5 em</span>
```

#### Font Weight
```dart
<span style="font-weight: bold;">Bold</span>
<span style="font-weight: 700;">Weight 700</span>
```

#### Font Style
```dart
<span style="font-style: italic;">Italic</span>
```

#### Text Decoration
```dart
<span style="text-decoration: underline;">Underlined</span>
<span style="text-decoration: line-through;">Strikethrough</span>
```

#### Background Color
```dart
<span style="background-color: yellow;">Highlighted</span>
```

### HTML Tags

The following HTML tags are supported with default styles:

- `<strong>`, `<b>` - Bold text
- `<em>`, `<i>` - Italic text
- `<u>` - Underlined text
- `<s>` - Strikethrough text
- `<mark>` - Highlighted text (yellow background)
- `<span>`, `<div>`, `<p>` - Generic containers

### Mixed Markdown and CSS

You can mix standard markdown syntax with CSS-styled HTML tags:

```dart
GptMarkdown(
  '''
  # Heading with <span style="color: red;">colored</span> text

  This is **bold** and this is <span style="color: blue;">blue</span>.

  - List item with <span style="background-color: yellow;">highlighted</span> text
  ''',
  components: [
    ...MarkdownComponent.globalComponents,
    HtmlTagMd(),
  ],
  inlineComponents: [
    ...MarkdownComponent.inlineComponents,
    HtmlTagMd(),
  ],
)
```

## API Reference

### CssParser

Static class for parsing CSS styles.

#### Methods

- `parseInlineStyle(String cssString, {TextStyle? baseStyle})` - Parse inline CSS string to TextStyle

### HtmlTagMd

Markdown component that handles HTML tags with CSS styles.

## Examples

See `example/lib/css_demo.dart` for complete examples.

## Limitations

- Only inline styles are supported (no external stylesheets or `<style>` tags)
- Limited CSS property support (common text styling properties only)
- No support for CSS selectors, pseudo-classes, or media queries
- No support for layout properties (margin, padding, width, height)

## License

MIT License - same as gpt_markdown
