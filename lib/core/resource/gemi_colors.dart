import 'dart:ui';

import 'package:flutter/material.dart';

abstract class GemiColors {
  static final light = GemiColorsLight.instance;
  static final dark = GemiColorsDark.instance;
  Color get textGradientStop1;
  Color get textGradientStop2;
  Color get textGradientStop3;
  Color get textColor;
  Color get bannerColor;
  Color get primaryColor;
  Color get backgroundColor;
  Color get surfaceColor;
}

class GemiColorsLight implements GemiColors {
  GemiColorsLight._();
  static final GemiColorsLight _instance = GemiColorsLight._();
  static GemiColorsLight get instance => _instance;

  @override
  Color get textGradientStop1 => const Color(0xFF4285F4);
  @override
  Color get textGradientStop2 => const Color(0xFF9B72CB);
  @override
  Color get textGradientStop3 => const Color(0xFFD96570);
  @override
  Color get textColor => const Color(0xFF1F1F1F);
  @override
  Color get bannerColor => const Color(0xFF041E49);
  @override
  Color get primaryColor => const Color(0xFF1F1F1F);
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF);

  @override
  // TODO: implement surfaceColor
  Color get surfaceColor => const Color(0xFFF0F4F9);
}

class GemiColorsDark implements GemiColors {
  GemiColorsDark._();
  static final GemiColorsDark _instance = GemiColorsDark._();
  static GemiColorsDark get instance => _instance;
  @override
  Color get textGradientStop1 => const Color(0xFF4285F4);
  @override
  Color get textGradientStop2 => const Color(0xFF9B72CB);
  @override
  Color get textGradientStop3 => const Color(0xFFD96570);
  @override
  Color get textColor => const Color(0xFFE0E0E0);
  @override
  Color get bannerColor => const Color(0xFF041E49);
  @override
  Color get primaryColor => const Color(0xFFE0E0E0);
  @override
  Color get backgroundColor => const Color(0xFF131314);

  @override
  Color get surfaceColor => const Color(0xFF1E1F20);
}

class GemiTheme {
  static final lightTheme = ThemeData.light().copyWith(
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: GemiColors.light.backgroundColor,
        ),
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: GemiColors.light.primaryColor,
          surface: GemiColors.light.surfaceColor,
        ),
    iconTheme: ThemeData.light().iconTheme.copyWith(),
    scaffoldBackgroundColor: GemiColors.light.backgroundColor,
  );

  static final darkTheme = ThemeData.dark().copyWith(
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          backgroundColor: GemiColors.dark.backgroundColor,
        ),
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          surface: GemiColors.dark.surfaceColor,
        ),
    iconTheme: IconThemeData(
      color: GemiColors.dark.primaryColor,
    ),
    scaffoldBackgroundColor: GemiColors.dark.backgroundColor,
  );
}
