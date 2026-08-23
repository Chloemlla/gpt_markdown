/// Powerful Flutter Markdown & LaTeX Renderer
library gpt_markdown_chloemlla;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/custom_divider.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/custom_error_image.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/custom_rb_cb.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/selectable_adapter.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/unordered_ordered_list.dart';
import 'package:gpt_markdown_chloemlla/custom_widgets/markdown_config.dart';
import 'dart:math';

import 'custom_widgets/code_field.dart';
import 'custom_widgets/inline_code.dart';
import 'custom_widgets/indent_widget.dart';
import 'custom_widgets/link_button.dart';
import 'streaming/streaming_markdown.dart';
import 'styles/block_quote_style.dart';
import 'styles/heading_style.dart';
import 'styles/link_style.dart';
import 'styles/list_style.dart';
import 'styles/checkbox_style.dart';
import 'styles/code_block_style.dart';
import 'styles/table_style.dart';
import 'styles/image_style.dart';
import 'styles/hr_style.dart';
import 'styles/source_tag_style.dart';
import 'styles/latex_style.dart';
import 'styles/gpt_markdown_style_sheet.dart';

// `GptMarkdownConfig` and the builder typedefs are part of the public API —
// custom components receive a config and consumers pass builders in.
export 'package:gpt_markdown_chloemlla/custom_widgets/markdown_config.dart';

// Inline `code` styling is configured by consumers.
export 'package:gpt_markdown_chloemlla/custom_widgets/inline_code.dart';

// Reveal animation for streamed replies.
export 'package:gpt_markdown_chloemlla/streaming/streaming_markdown.dart';
export 'package:gpt_markdown_chloemlla/streaming/reveal_engine.dart';
export 'package:gpt_markdown_chloemlla/streaming/stream_split.dart';

// Per-component appearance.
export 'package:gpt_markdown_chloemlla/styles/block_quote_style.dart';
export 'package:gpt_markdown_chloemlla/styles/heading_style.dart';
export 'package:gpt_markdown_chloemlla/styles/link_style.dart';
export 'package:gpt_markdown_chloemlla/styles/list_style.dart';
export 'package:gpt_markdown_chloemlla/styles/checkbox_style.dart';
export 'package:gpt_markdown_chloemlla/styles/code_block_style.dart';
export 'package:gpt_markdown_chloemlla/styles/table_style.dart';
export 'package:gpt_markdown_chloemlla/styles/image_style.dart';
export 'package:gpt_markdown_chloemlla/styles/hr_style.dart';
export 'package:gpt_markdown_chloemlla/styles/source_tag_style.dart';
export 'package:gpt_markdown_chloemlla/styles/latex_style.dart';
export 'package:gpt_markdown_chloemlla/styles/gpt_markdown_style_sheet.dart';

part 'theme.dart';
part 'inline_pattern.dart';
part 'autolink.dart';
part 'markdown_component.dart';
part 'md_widget.dart';
part 'gpt_markdown.dart';
