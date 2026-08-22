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

// `GptMarkdownConfig` and the builder typedefs are part of the public API —
// custom components receive a config and consumers pass builders in.
export 'package:gpt_markdown_chloemlla/custom_widgets/markdown_config.dart';

// Inline `code` styling is configured by consumers.
export 'package:gpt_markdown_chloemlla/custom_widgets/inline_code.dart';

part 'theme.dart';
part 'inline_pattern.dart';
part 'autolink.dart';
part 'markdown_component.dart';
part 'md_widget.dart';
part 'gpt_markdown.dart';
