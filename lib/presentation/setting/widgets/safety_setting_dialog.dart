import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/model/gemini/gemini_safety/safety_category.dart';
import '../../../data/model/gemini/gemini_safety/safety_threshold.dart';

class SafetySettingDialog extends StatelessWidget {
  final Map<SafetyCategory, int> safetySettings;
  final bool isLoading;
  final Function(Map<SafetyCategory, int>)? onSave;

  const SafetySettingDialog({
    super.key,
    this.safetySettings = const {},
    this.isLoading = false,
    this.onSave,
  });

  Widget _buildSlider(SafetyCategory category, int value, int maxVal,
      Function(double) onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(category.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Slider(
        label: SafetyThreshold.values[value].displayName,
        min: 0,
        max: maxVal.toDouble(),
        value: value.toDouble(),
        divisions: maxVal,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setDialogState) {
      return AlertDialog(
        title: const ListTile(
          leading: Icon(Icons.security),
          title: Text("Run safety settings"),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Adjust how likely you are to see responses that could be harmful. Content is blocked based on the probability that it is harmful.',
              ),
              const Divider(),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ...SafetyCategory.values.map((e) {
                  return Column(
                    children: [
                      _buildSlider(e, safetySettings[e] ?? 0,
                          SafetyThreshold.values.length - 2, (value) {
                        setDialogState(() {
                          safetySettings[e] = value.toInt();
                        });
                      }),
                      if (e != SafetyCategory.values.last) const Divider(),
                    ],
                  );
                }),
              const Divider(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Reset defaults"),
          ),
          TextButton(
            onPressed: () {
              onSave?.call(safetySettings);
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      );
    });
  }
}
