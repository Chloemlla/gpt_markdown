# CSS Support Documentation

## Overview

The `gpt_markdown_chloemlla` package now includes comprehensive CSS support through the `csslib` library. This allows you to:

- Parse complete CSS stylesheets (like GitHub's markdown CSS)
- Extract and apply CSS variables
- Convert CSS styles to Flutter TextStyles
- Create themed markdown renderers

## Features

### 1. CSS Stylesheet Parsing

Parse complete CSS files including:
- CSS variables (custom properties)
- Media queries
- Complex selectors
- Multiple rule sets

### 2. CSS Variable Resolution

Automatically resolve CSS variable references:
```css
:root {
  --primary-color: #4493f8;
  --link-color: var(--primary-color);
}
```

### 3. Style Extraction

Extract styles for specific selectors:
```dart
final stylesheet = CssStylesheet.parse(cssContent);
final h1Styles = stylesheet.getStylesForSelector('.markdown-body h1');
```

### 4. Theme Management

Create Flutter themes from CSS:
```dart
final theme = await CssTheme.fromAsset('assets/github-markdown.css');
final textStyle = theme.getTextStyle('.markdown-body h1');
final color = theme.getColor('--fgColor-default');
```

## Usage

### Basic Usage

```dart
import 'package:gpt_markdown_chloemlla/css/css.dart';

// Load CSS from asset
final theme = await CssTheme.fromAsset('assets/github-markdown.css');

// Get text style for a selector
final h1Style = theme.getTextStyle('.markdown-body h1');

// Get color from CSS variable
final accentColor = theme.getColor('--fgColor-accent');

// Get all CSS variables
final variables = theme.getAllVariables();
```

### Using with Markdown

```dart
import 'package:gpt_markdown_chloemlla/gpt_markdown_chloemlla.dart';
import 'package:gpt_markdown_chloemlla/css/css.dart';

class MarkdownWithCss extends StatefulWidget {
  @override
  State<MarkdownWithCss> createState() => _MarkdownWithCssState();
}

class _MarkdownWithCssState extends State<MarkdownWithCss> {
  CssTheme? _cssTheme;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await CssTheme.fromAsset('assets/github-markdown.css');
    setState(() => _cssTheme = theme);
  }

  @override
  Widget build(BuildContext context) {
    if (_cssTheme == null) {
      return CircularProgressIndicator();
    }

    return MarkdownWidget(
      '# Hello World\n\nThis is **bold** and *italic*.',
      config: GptMarkdownConfig(
        style: _cssTheme!.getTextStyle('.markdown-body'),
        h1: _cssTheme!.getTextStyle('.markdown-body h1'),
        h2: _cssTheme!.getTextStyle('.markdown-body h2'),
        // ... other styles
      ),
    );
  }
}
```

### Inline CSS Parsing

```dart
import 'package:gpt_markdown_chloemlla/css/css.dart';

// Parse inline style attribute
final style = CssParser.parseInlineStyle(
  'color: #1f2328; font-size: 16px; font-weight: 600',
);

// Parse from properties map
final properties = {
  'color': '#1f2328',
  'font-size': '16px',
  'font-weight': '600',
};
final style = CssParser.parsePropertiesMap(properties);
```

## Supported CSS Features

### Properties

- `color` - Text color (hex, rgb, rgba, named colors)
- `background-color` - Background color
- `font-size` - Font size (px, pt, em, rem)
- `font-weight` - Font weight (normal, bold, 100-900)
- `font-style` - Font style (normal, italic)
- `font-family` - Font family
- `text-decoration` - Text decoration (underline, line-through, overline)

### Color Formats

- Hex: `#RGB`, `#RRGGBB`, `#RRGGBBAA`
- RGB: `rgb(r, g, b)`
- RGBA: `rgba(r, g, b, a)`
- Named colors: `red`, `blue`, `green`, etc.
- Transparent: `transparent`

### Size Units

- `px` - Pixels
- `pt` - Points (converted to pixels)
- `em` - Relative to base font size (16px)
- `rem` - Relative to root font size (16px)

### CSS Variables

```css
:root {
  --primary-color: #4493f8;
  --font-size: 16px;
}

.element {
  color: var(--primary-color);
  font-size: var(--font-size);
}
```

## GitHub Markdown CSS Example

### 1. Add CSS to assets

Add `github-markdown.css` to your `assets/` folder.

### 2. Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/github-markdown.css
```

### 3. Load and use the theme

```dart
final theme = await CssTheme.fromAsset('assets/github-markdown.css');

// Access CSS variables
final bgColor = theme.getColor('--bgColor-default');
final fgColor = theme.getColor('--fgColor-default');
final accentColor = theme.getColor('--fgColor-accent');

// Access element styles
final h1Style = theme.getTextStyle('.markdown-body h1');
final codeStyle = theme.getTextStyle('.markdown-body code');
final linkStyle = theme.getTextStyle('.markdown-body a');
```

## Advanced Usage

### Custom CSS Stylesheet

```dart
const customCss = '''
  :root {
    --primary: #007bff;
    --secondary: #6c757d;
    --success: #28a745;
    --danger: #dc3545;
  }

  .custom-markdown {
    color: #333;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto;
  }

  .custom-markdown h1 {
    color: var(--primary);
    font-size: 2.5em;
    font-weight: 700;
  }

  .custom-markdown code {
    background-color: #f5f5f5;
    padding: 2px 4px;
    border-radius: 3px;
  }
''';

final theme = CssTheme.fromString(customCss);
```

### Caching and Performance

The `CssTheme` class automatically caches parsed styles for better performance:

```dart
// First call parses and caches
final style1 = theme.getTextStyle('.markdown-body h1');

// Second call returns cached result
final style2 = theme.getTextStyle('.markdown-body h1');

// Same instance
assert(identical(style1, style2));
```

## API Reference

### CssStylesheet

```dart
class CssStylesheet {
  // Parse CSS from string
  static CssStylesheet parse(String cssContent);

  // Get CSS variable value
  String? getCssVariable(String variableName);

  // Resolve CSS variable references
  String resolveCssVariables(String value);

  // Get styles for selector
  Map<String, String> getStylesForSelector(String selector);

  // Get all CSS variables
  Map<String, String> getAllVariables();
}
```

### CssTheme

```dart
class CssTheme {
  // Load from asset
  static Future<CssTheme> fromAsset(String assetPath);

  // Load from string
  static CssTheme fromString(String cssContent);

  // Get TextStyle for selector
  TextStyle? getTextStyle(String selector, {TextStyle? baseStyle});

  // Get color from CSS variable
  Color? getColor(String variableName);

  // Get all CSS variables
  Map<String, String> getAllVariables();
}
```

### CssParser

```dart
class CssParser {
  // Parse inline style string
  static TextStyle? parseInlineStyle(
    String cssString,
    {TextStyle? baseStyle}
  );

  // Parse from properties map
  static TextStyle? parsePropertiesMap(
    Map<String, String> properties,
    {TextStyle? baseStyle}
  );
}
```

## Examples

See the `example/` directory for complete examples:

- `css_demo.dart` - Basic CSS parsing demo
- `css_stylesheet_demo.dart` - Full stylesheet demo with GitHub CSS

## Limitations

- Pseudo-classes and pseudo-elements are not fully supported
- Complex selector matching is simplified
- Some CSS properties are not supported (only text-related properties)
- Media queries are parsed but not dynamically evaluated

## Future Enhancements

- [ ] Dynamic media query evaluation
- [ ] More CSS properties support
- [ ] Better selector matching
- [ ] CSS animations support
- [ ] Responsive design utilities
