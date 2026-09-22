// The CSS support rides the legacy component pipeline: `HtmlTagMd` is an
// `InlineMd`, and the CSS-aware components are spread into the legacy
// `components` / `inlineComponents` lists. Every `GptMarkdown` call below is
// therefore deliberately on the deprecated path; moving to `blockComponents` /
// `inlineDirectives` is a feature change, not a rename — an html tag with a
// style attribute is exactly the "delimited payload" `InlineDirective` exists
// for, so porting `HtmlTagMd` onto it is the follow-up.
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gpt_markdown_chloemlla/gpt_markdown_chloemlla.dart';
import 'package:gpt_markdown_chloemlla/css/css.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Markdown CSS Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CssDemoPage(),
    );
  }
}

class CssDemoPage extends StatelessWidget {
  const CssDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GPT Markdown CSS Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CSS Style Support Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Example 1: Inline CSS styles
            const Text(
              'Example 1: Inline CSS Styles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GptMarkdown(
              '''
<span style="color: #ff0000; font-size: 20px; font-weight: bold;">Red bold text</span>

<span style="color: rgb(0, 128, 0); font-style: italic;">Green italic text</span>

<span style="background-color: yellow; color: black;">Highlighted text</span>
              ''',
              components: [
                ...MarkdownComponent.globalComponents,
                HtmlTagMd(),
              ],
              inlineComponents: [
                ...MarkdownComponent.inlineComponents,
                HtmlTagMd(),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Example 2: HTML tags with CSS
            const Text(
              'Example 2: HTML Tags with CSS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GptMarkdown(
              '''
<strong style="color: blue;">Bold blue text</strong>

<em style="color: purple; font-size: 18px;">Italic purple text</em>

<u style="color: green;">Underlined green text</u>

<s style="color: red;">Strikethrough red text</s>

<mark>Marked/highlighted text</mark>
              ''',
              components: [
                ...MarkdownComponent.globalComponents,
                HtmlTagMd(),
              ],
              inlineComponents: [
                ...MarkdownComponent.inlineComponents,
                HtmlTagMd(),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Example 3: Mixed Markdown and CSS
            const Text(
              'Example 3: Mixed Markdown and CSS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GptMarkdown(
              '''
# Heading with <span style="color: red;">colored</span> text

This is **bold** and this is <span style="color: blue; font-weight: bold;">blue bold</span>.

- List item with <span style="background-color: yellow;">highlighted</span> text
- Another item with *italic* and <em style="color: green;">green italic</em>

> Blockquote with <span style="font-size: 20px; color: purple;">large purple text</span>
              ''',
              components: [
                ...MarkdownComponent.globalComponents,
                HtmlTagMd(),
              ],
              inlineComponents: [
                ...MarkdownComponent.inlineComponents,
                HtmlTagMd(),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Example 4: Complex CSS styles
            const Text(
              'Example 4: Complex CSS Styles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GptMarkdown(
              '''
<span style="color: #3498db; font-size: 24px; font-weight: 700; font-family: Arial;">
  Custom styled text with multiple properties
</span>

<span style="color: rgba(255, 0, 0, 0.5); background-color: rgba(0, 0, 255, 0.2); font-size: 16px;">
  Semi-transparent colors
</span>
              ''',
              components: [
                ...MarkdownComponent.globalComponents,
                HtmlTagMd(),
              ],
              inlineComponents: [
                ...MarkdownComponent.inlineComponents,
                HtmlTagMd(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
