import 'package:flutter/material.dart';
import 'package:gemi/core/resource/assets.dart';

import 'gradient_text.dart';
import 'promt_suggestion_chip.dart';

class PromptSuggestion extends StatelessWidget {
  final List<PromptSuggestChip> promptSuggestChips = [
    PromptSuggestChip(
      label: "I'm feeling anxious",
      icon: Icons.sentiment_very_dissatisfied_rounded,
    ),
    PromptSuggestChip(
      label: "I'm feeling sad",
      icon: Icons.sentiment_dissatisfied_rounded,
    ),
    PromptSuggestChip(
      label: "I'm feeling angry",
      icon: Icons.sentiment_neutral_rounded,
    ),
    PromptSuggestChip(
      label: "I'm feeling happy",
      icon: Icons.sentiment_satisfied_rounded,
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
              Image.asset(
                Assets.sparkleResting,
                scale: 1.75,
              ),
              GradientText(
                "Hello Hào.",
                gradient: const LinearGradient(
                  colors: <Color>[
                    //f49c48
                    Color(0xffF49C48),
                    //#cf8d7c
                    Color(0xffCF8D7C),
                  ],
                ),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text("How can I help you today?",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      )),
            ],
          ),
        ),
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
                  SuggestionPromptCard(
                    key: UniqueKey(),
                    promptSuggestChips: promptSuggestChips,
                    gradient: const LinearGradient(
                      colors: <Color>[
                        //f49c48
                        Color(0xffcf8d7c),
                        //#cf8d7c
                        Color(0xffa77cb4),
                      ],
                    ),
                  ),
                  SuggestionPromptCard(
                    key: UniqueKey(),
                    promptSuggestChips: promptSuggestChips,
                    gradient: const LinearGradient(
                      colors: <Color>[
                        //f49c48
                        Color(0xffa77cb4),
                        //#cf8d7c
                        Color(0xff7f7dd1),
                      ],
                    ),
                  ),
                  SuggestionPromptCard(
                    key: UniqueKey(),
                    promptSuggestChips: promptSuggestChips,
                    gradient: const LinearGradient(
                      colors: <Color>[
                        //f49c48
                        Color(0xff7f7dd1),
                        //#cf8d7c
                        Color(0xff548dd9),
                      ],
                    ),
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
