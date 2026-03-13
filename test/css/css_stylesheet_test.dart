import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_markdown_chloemlla/css/css.dart';

void main() {
  group('CssStylesheet', () {
    test('should parse CSS variables', () {
      const cssContent = '''
        :root {
          --primary-color: #4493f8;
          --font-size: 16px;
          --spacing: 1rem;
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final variables = stylesheet.getAllVariables();

      expect(variables['--primary-color'], equals('#4493f8'));
      expect(variables['--font-size'], equals('16px'));
      expect(variables['--spacing'], equals('1rem'));
    });

    test('should resolve CSS variable references', () {
      const cssContent = '''
        :root {
          --primary-color: #4493f8;
          --link-color: var(--primary-color);
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final resolved = stylesheet.resolveCssVariables('var(--primary-color)');

      expect(resolved, equals('#4493f8'));
    });

    test('should resolve CSS variables with fallback', () {
      const cssContent = '''
        :root {
          --primary-color: #4493f8;
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final resolved = stylesheet.resolveCssVariables('var(--missing-color, #000000)');

      expect(resolved, equals('#000000'));
    });

    test('should extract styles for selector', () {
      const cssContent = '''
        .markdown-body {
          color: #1f2328;
          font-size: 16px;
          line-height: 1.5;
        }

        .markdown-body h1 {
          font-size: 2em;
          font-weight: 600;
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final bodyStyles = stylesheet.getStylesForSelector('.markdown-body');
      final h1Styles = stylesheet.getStylesForSelector('.markdown-body h1');

      expect(bodyStyles['color'], equals('#1f2328'));
      expect(bodyStyles['font-size'], equals('16px'));
      expect(bodyStyles['line-height'], equals('1.5'));

      expect(h1Styles['font-size'], equals('2em'));
      expect(h1Styles['font-weight'], equals('600'));
    });

    test('should handle media queries', () {
      const cssContent = '''
        :root {
          --bg-color: #ffffff;
        }

        @media (prefers-color-scheme: dark) {
          :root {
            --bg-color: #0d1117;
          }
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final variables = stylesheet.getAllVariables();

      // Should contain both light and dark mode variables
      expect(variables.containsKey('--bg-color'), isTrue);
    });

    test('should handle complex selectors', () {
      const cssContent = '''
        .markdown-body h1,
        .markdown-body h2,
        .markdown-body h3 {
          font-weight: 600;
          margin-top: 24px;
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final h1Styles = stylesheet.getStylesForSelector('.markdown-body h1');
      final h2Styles = stylesheet.getStylesForSelector('.markdown-body h2');

      expect(h1Styles['font-weight'], equals('600'));
      expect(h2Styles['font-weight'], equals('600'));
    });
  });

  group('CssTheme', () {
    test('should create theme from CSS string', () {
      const cssContent = '''
        :root {
          --fgColor-default: #1f2328;
          --bgColor-default: #ffffff;
        }

        .markdown-body {
          color: var(--fgColor-default);
          background-color: var(--bgColor-default);
        }
      ''';

      final theme = CssTheme.fromString(cssContent);

      expect(theme.getColor('--fgColor-default'), isNotNull);
      expect(theme.getColor('--bgColor-default'), isNotNull);
    });

    test('should get text styles for selectors', () {
      const cssContent = '''
        .markdown-body h1 {
          font-size: 2em;
          font-weight: 600;
          color: #1f2328;
        }
      ''';

      final theme = CssTheme.fromString(cssContent);
      final h1Style = theme.getTextStyle('.markdown-body h1');

      expect(h1Style, isNotNull);
      expect(h1Style!.fontSize, equals(32.0)); // 2em = 32px
      expect(h1Style.fontWeight, equals(FontWeight.w600));
    });

    test('should cache text styles', () {
      const cssContent = '''
        .markdown-body p {
          font-size: 16px;
        }
      ''';

      final theme = CssTheme.fromString(cssContent);
      final style1 = theme.getTextStyle('.markdown-body p');
      final style2 = theme.getTextStyle('.markdown-body p');

      expect(identical(style1, style2), isTrue);
    });
  });

  group('CssParser enhancements', () {
    test('should parse rem units', () {
      const cssString = 'font-size: 1.5rem';
      final style = CssParser.parseInlineStyle(cssString);

      expect(style?.fontSize, equals(24.0)); // 1.5rem = 24px
    });

    test('should parse short hex colors', () {
      const cssString = 'color: #f00';
      final style = CssParser.parseInlineStyle(cssString);

      expect(style?.color, isNotNull);
    });

    test('should handle transparent color', () {
      const cssString = 'background-color: transparent';
      final style = CssParser.parseInlineStyle(cssString);

      expect(style?.backgroundColor, isNotNull);
    });

    test('should parse properties map', () {
      final properties = {
        'color': '#1f2328',
        'font-size': '16px',
        'font-weight': '600',
      };

      final style = CssParser.parsePropertiesMap(properties);

      expect(style?.color, isNotNull);
      expect(style?.fontSize, equals(16.0));
      expect(style?.fontWeight, equals(FontWeight.w600));
    });
  });

  group('GitHub Markdown CSS Integration', () {
    test('should parse complex GitHub markdown CSS', () {
      // Simplified version of GitHub markdown CSS
      const cssContent = '''
        .markdown-body {
          --base-size-16: 1rem;
          --base-text-weight-normal: 400;
          --base-text-weight-semibold: 600;
          --fgColor-default: #1f2328;
          --bgColor-default: #ffffff;
          --borderColor-default: #d1d9e0;

          color: var(--fgColor-default);
          background-color: var(--bgColor-default);
          font-size: 16px;
          line-height: 1.5;
        }

        .markdown-body h1 {
          font-size: 2em;
          font-weight: var(--base-text-weight-semibold, 600);
          border-bottom: 1px solid var(--borderColor-default);
        }

        .markdown-body code {
          font-family: monospace;
          font-size: 85%;
          padding: 0.2em 0.4em;
        }
      ''';

      final stylesheet = CssStylesheet.parse(cssContent);
      final variables = stylesheet.getAllVariables();

      expect(variables['--fgColor-default'], equals('#1f2328'));
      expect(variables['--bgColor-default'], equals('#ffffff'));

      final bodyStyles = stylesheet.getStylesForSelector('.markdown-body');
      expect(bodyStyles['font-size'], equals('16px'));
      expect(bodyStyles['line-height'], equals('1.5'));

      final h1Styles = stylesheet.getStylesForSelector('.markdown-body h1');
      expect(h1Styles['font-size'], equals('2em'));
    });
  });
}
