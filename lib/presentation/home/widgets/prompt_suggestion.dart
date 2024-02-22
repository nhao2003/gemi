import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemi/core/resource/assets.dart';

import 'gradient_text.dart';
import 'promt_suggestion_chip.dart';

class PromptSuggestChip {
  final String label;
  final IconData icon;
  const PromptSuggestChip({required this.label, required this.icon});
}

class PromptSuggestion extends StatelessWidget {
  final List<dynamic> promptSuggestChips = const [
    PromptSuggestChip(
      label: "Create vibrant & playful image with lots of details",
      icon: Icons.draw_outlined,
    ),
    PromptSuggestChip(
      label: "Brainstorm team bonding activities for our work retreat",
      icon: Icons.lightbulb_outline_rounded,
    ),
    PromptSuggestChip(
      label: "Create a travel itinerary for a city",
      icon: Icons.code,
    ),
    PromptSuggestChip(
      label: "Help me craft an OOO message based on a few details",
      icon: Icons.draw_outlined,
    ),
    PromptSuggestChip(
      label: "What's the time it takes to walk to several landmarks",
      icon: Icons.map_rounded,
    ),
  ];
  EdgeInsetsGeometry? listPromptPadding;
  EdgeInsetsGeometry? padding;
  PromptSuggestion({this.listPromptPadding, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              GradientText(
                "Hello Hào.",
                gradient: const LinearGradient(
                  colors: <Color>[
                    //f49c48
                    Color(
                        0xFF4285F4), // --bard-color-brand-text-gradient-stop-1
                    Color(
                        0xFF9B72CB), // --bard-color-brand-text-gradient-stop-2
                    Color(0xFFD96570),
                  ],
                ),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text("How can I help you today?",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFC4C7C5),
                      )),
            ],
          ),
        ),
        SizedBox(height: 40),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: listPromptPadding?.horizontal ?? 0,
            vertical: listPromptPadding?.vertical ?? 0,
          ),
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (var chip in promptSuggestChips)
                    PromptContainer(
                      title: chip.label,
                      icon: chip.icon,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
