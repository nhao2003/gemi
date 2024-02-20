import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
    this.isSelectable,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final bool? isSelectable;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: isSelectable == true
          ? SelectableText(
              text,
              style: style,
            )
          : Text(
              text,
              style: style,
            ),
    );
  }
}
