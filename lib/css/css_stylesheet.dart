import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;

/// CSS Stylesheet manager that parses and stores CSS rules
class CssStylesheet {
  final css.StyleSheet _stylesheet;
  final Map<String, String> _cssVariables = {};
  final Map<String, Map<String, String>> _ruleCache = {};

  CssStylesheet._(this._stylesheet) {
    _extractCssVariables();
  }

  /// Parse CSS from string
  static CssStylesheet parse(String cssContent) {
    final stylesheet = css.parse(cssContent);
    return CssStylesheet._(stylesheet);
  }

  /// Extract CSS variables from :root and other selectors
  void _extractCssVariables() {
    for (final rule in _stylesheet.topLevels) {
      if (rule is css.RuleSet) {
        _extractVariablesFromRuleSet(rule);
      } else if (rule is css.MediaDirective) {
        for (final mediaRule in rule.rules) {
          if (mediaRule is css.RuleSet) {
            _extractVariablesFromRuleSet(mediaRule);
          }
        }
      }
    }
  }

  void _extractVariablesFromRuleSet(css.RuleSet ruleSet) {
    for (final declaration in ruleSet.declarationGroup.declarations) {
      if (declaration is css.Declaration) {
        final propertyName = _getPropertyName(declaration);
        if (propertyName.startsWith('--')) {
          final value = _expressionToString(declaration.expression);
          _cssVariables[propertyName] = value;
        }
      }
    }
  }

  String _getPropertyName(css.Declaration declaration) {
    final text = declaration.span.text;
    final colonIndex = text.indexOf(':');
    if (colonIndex > 0) {
      return text.substring(0, colonIndex).trim();
    }
    return declaration.property.toString();
  }

  /// Get CSS variable value
  String? getCssVariable(String variableName) {
    return _cssVariables[variableName];
  }

  /// Resolve CSS variable references (var(--variable-name))
  String resolveCssVariables(String value) {
    final varPattern = RegExp(r'var\((--[a-zA-Z0-9-]+)(?:,\s*([^)]+))?\)');
    return value.replaceAllMapped(varPattern, (match) {
      final varName = match.group(1)!;
      final fallback = match.group(2);
      return _cssVariables[varName] ?? fallback ?? match.group(0)!;
    });
  }

  /// Get styles for a specific selector (e.g., ".markdown-body", ".markdown-body h1")
  Map<String, String> getStylesForSelector(String selector) {
    if (_ruleCache.containsKey(selector)) {
      return _ruleCache[selector]!;
    }

    final styles = <String, String>{};

    for (final rule in _stylesheet.topLevels) {
      if (rule is css.RuleSet) {
        _matchAndExtractStyles(rule, selector, styles);
      } else if (rule is css.MediaDirective) {
        for (final mediaRule in rule.rules) {
          if (mediaRule is css.RuleSet) {
            _matchAndExtractStyles(mediaRule, selector, styles);
          }
        }
      }
    }

    _ruleCache[selector] = styles;
    return styles;
  }

  void _matchAndExtractStyles(
    css.RuleSet ruleSet,
    String targetSelector,
    Map<String, String> styles,
  ) {
    final selectorGroup = ruleSet.selectorGroup;
    if (selectorGroup == null) return;

    for (final selector in selectorGroup.selectors) {
      final selectorText = _selectorToString(selector);
      if (_matchesSelector(selectorText, targetSelector)) {
        _extractDeclarations(ruleSet, styles);
      }
    }
  }

  void _extractDeclarations(css.RuleSet ruleSet, Map<String, String> styles) {
    for (final declaration in ruleSet.declarationGroup.declarations) {
      if (declaration is css.Declaration) {
        final propertyName = _getPropertyName(declaration);
        if (!propertyName.startsWith('--')) {
          final value = _expressionToString(declaration.expression);
          styles[propertyName] = resolveCssVariables(value);
        }
      }
    }
  }

  bool _matchesSelector(String ruleSelector, String targetSelector) {
    // Simple matching - exact match or contains
    ruleSelector = ruleSelector.trim();
    targetSelector = targetSelector.trim();

    // Remove pseudo-classes and pseudo-elements for basic matching
    ruleSelector = ruleSelector.replaceAll(RegExp(r'::[a-z-]+'), '');
    ruleSelector = ruleSelector.replaceAll(
      RegExp(r':[a-z-]+(?:\([^)]*\))?'),
      '',
    );

    return ruleSelector == targetSelector ||
        ruleSelector.contains(targetSelector) ||
        targetSelector.contains(ruleSelector);
  }

  String _selectorToString(css.Selector selector) {
    final buffer = StringBuffer();
    for (final part in selector.simpleSelectorSequences) {
      buffer.write(_simpleSelectorToString(part.simpleSelector));
      if (part.combinator != css.TokenKind.COMBINATOR_NONE) {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }

  String _simpleSelectorToString(css.SimpleSelector selector) {
    if (selector is css.ElementSelector) {
      return selector.name;
    } else if (selector is css.ClassSelector) {
      return '.${selector.name}';
    } else if (selector is css.IdSelector) {
      return '#${selector.name}';
    } else if (selector is css.AttributeSelector) {
      return '[${selector.name}]';
    } else if (selector is css.PseudoClassSelector) {
      return ':${selector.name}';
    } else if (selector is css.PseudoElementSelector) {
      return '::${selector.name}';
    }
    return selector.toString();
  }

  String _expressionToString(css.Expression? expression) {
    if (expression == null) return '';

    final buffer = StringBuffer();

    // Use the visitor pattern to extract the value
    for (final term in expression.span!.text.trim().split(RegExp(r'\s+'))) {
      final cleaned = term.trim();
      if (cleaned.isNotEmpty) {
        if (buffer.isNotEmpty) buffer.write(' ');
        buffer.write(cleaned);
      }
    }

    final result = buffer.toString();
    return result.isNotEmpty ? result : expression.span!.text.trim();
  }

  /// Get all CSS variables
  Map<String, String> getAllVariables() => Map.unmodifiable(_cssVariables);
}
