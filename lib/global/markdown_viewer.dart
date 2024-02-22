import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeElementBuilder extends MarkdownElementBuilder {
  BuildContext context;
  CodeElementBuilder({required this.context});

  @override
  Widget? visitElementAfter(dynamic element, TextStyle? preferredStyle) {
    var language = '';
    String codeLanguage = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
      // Upper case the first letter
      codeLanguage = language[0].toUpperCase() + language.substring(1);
    }
    Map<String, TextStyle> theme = Map.from(atomOneDarkTheme);

    theme['root'] = theme['root']!
        .copyWith(backgroundColor: Theme.of(context).colorScheme.surface);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(codeLanguage),
          ),
          SizedBox(
            width: double.infinity,
            child: HighlightView(
              element.textContent,
              language: language,
              theme: theme,
              padding: const EdgeInsets.all(8),
              textStyle: GoogleFonts.robotoMono(),
            ),
          ),
          //Use code with caution
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Use code ',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: 'with caution',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Thực hiện hành động khi nhấp vào "with caution" ở đây
                            // Ví dụ: mở đường link
                            // launch('https://your-link.com');
                          },
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          // Bất kỳ style nào bạn muốn áp dụng cho phần được gạch chân ở đây
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MarkDownViewer extends StatelessWidget {
  final String data;
  const MarkDownViewer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      builders: {
        'code': CodeElementBuilder(
          context: context,
        ),
      },
    );
  }
}
