import 'package:flutter/material.dart';

import 'gradient_text.dart';

class PromptSuggestChip {
  final dynamic id;
  final String label;
  final IconData icon;

  PromptSuggestChip({
    this.id,
    required this.label,
    required this.icon,
  });
}

class SuggestionPromptCard extends StatelessWidget {
  final List<PromptSuggestChip> promptSuggestChips;
  // Callback with the selected chip
  final Function(PromptSuggestChip)? onPressed;
  final Gradient? gradient;
  const SuggestionPromptCard(
      {super.key,
      this.promptSuggestChips = const [],
      this.onPressed,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      constraints: const BoxConstraints(
        minWidth: 250,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Stretch the row to the full width
            mainAxisSize: MainAxisSize.max,
            children: [
              GradientText("Explore",
                  gradient: gradient ??
                      const LinearGradient(
                        colors: <Color>[
                          //f49c48
                          Color(0xffF49C48),
                          //#cf8d7c
                          Color(0xffCF8D7C),
                        ],
                      ),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              IconButton(onPressed: () {}, icon: Icon(Icons.close_rounded)),
            ],
          ),
          ...promptSuggestChips
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InputChip(
                      onPressed: () {
                        onPressed?.call(e);
                      },
                      avatar: Icon(e.icon),
                      label: Text(e.label),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
