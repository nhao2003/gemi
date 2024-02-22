import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'gradient_text.dart';

class PromptContainer extends StatelessWidget {
  // Callback with the selected chip
  final Function(String)? onPressed;
  final String title;
  final IconData icon;

  const PromptContainer({
    required this.title,
    required this.icon,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        // #f0f4f9
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  radius: 30,
                  child: Icon(
                    icon,
                    size: 40,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
