import 'package:flutter/material.dart';
import 'package:gpt_markdown_chloemlla/css/css.dart';

/// Example demonstrating full CSS stylesheet support
class CssStylesheetDemo extends StatefulWidget {
  const CssStylesheetDemo({super.key});

  @override
  State<CssStylesheetDemo> createState() => _CssStylesheetDemoState();
}

class _CssStylesheetDemoState extends State<CssStylesheetDemo> {
  CssTheme? _cssTheme;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCssTheme();
  }

  Future<void> _loadCssTheme() async {
    try {
      final theme = await CssTheme.fromAsset('assets/github-markdown.css');
      setState(() {
        _cssTheme = theme;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('CSS Stylesheet Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading CSS: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadCssTheme();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final theme = _cssTheme!;
    final variables = theme.getAllVariables();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS Stylesheet Demo'),
        backgroundColor: theme.getColor('--bgColor-default'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'CSS Variables',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loaded ${variables.length} CSS variables',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...variables.entries.take(10).map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    )),
                if (variables.length > 10)
                  Text(
                    '... and ${variables.length - 10} more',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Heading Styles',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Heading 1',
                    style: theme.getTextStyle('.markdown-body h1')),
                const SizedBox(height: 8),
                Text('Heading 2',
                    style: theme.getTextStyle('.markdown-body h2')),
                const SizedBox(height: 8),
                Text('Heading 3',
                    style: theme.getTextStyle('.markdown-body h3')),
                const SizedBox(height: 8),
                Text('Heading 4',
                    style: theme.getTextStyle('.markdown-body h4')),
                const SizedBox(height: 8),
                Text('Heading 5',
                    style: theme.getTextStyle('.markdown-body h5')),
                const SizedBox(height: 8),
                Text('Heading 6',
                    style: theme.getTextStyle('.markdown-body h6')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Text Styles',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Normal paragraph text',
                  style: theme.getTextStyle('.markdown-body p'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bold text',
                  style: theme.getTextStyle('.markdown-body strong'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Italic text',
                  style: theme.getTextStyle('.markdown-body em'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Link text',
                  style: theme.getTextStyle('.markdown-body a'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Code text',
                  style: theme.getTextStyle('.markdown-body code'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Colors',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColorRow(
                    'Background', theme.getColor('--bgColor-default')),
                _buildColorRow(
                    'Foreground', theme.getColor('--fgColor-default')),
                _buildColorRow('Accent', theme.getColor('--fgColor-accent')),
                _buildColorRow('Muted', theme.getColor('--fgColor-muted')),
                _buildColorRow(
                    'Border', theme.getColor('--borderColor-default')),
                _buildColorRow('Success', theme.getColor('--fgColor-success')),
                _buildColorRow('Danger', theme.getColor('--fgColor-danger')),
                _buildColorRow(
                    'Attention', theme.getColor('--fgColor-attention')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(String label, Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color ?? Colors.grey,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  color?.toString() ?? 'null',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
