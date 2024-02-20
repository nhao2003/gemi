import 'package:flutter/material.dart';
import 'package:gemi/domain/enums/enums.dart';

import 'prompt_suggestion.dart';

class HomeWelcome extends StatelessWidget {
  const HomeWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    Breakpoint breakpoint =
        Breakpoint.fromWidth(MediaQuery.of(context).size.width);
    return SingleChildScrollView(
      child: PromptSuggestion(
        padding: breakpoint == Breakpoint.mobile
            ? const EdgeInsets.all(8)
            : const EdgeInsets.only(top: 16, left: 100, right: 100),
        listPromptPadding: breakpoint != Breakpoint.mobile
            ? const EdgeInsets.symmetric(horizontal: 50, vertical: 8)
            : const EdgeInsets.all(0),
      ),
    );
  }
}
