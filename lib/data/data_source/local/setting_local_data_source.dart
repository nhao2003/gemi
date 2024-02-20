import 'package:flutter/material.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingLocalDataSource {
  Future<void> setThemeMode(ThemeMode themeMode);
  ThemeMode getThemeMode();
  Future<Map<SafetyCategory, int>> getSafetyCategorySettings({
    int defaultSetting = 0,
  });
  Future<void> setSafetyCategorySettings(
    Map<SafetyCategory, int> safetyCategorySettings, {
    int defaultSetting = 0,
  });
}

class SettingLocalDataSourceImpl implements SettingLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingLocalDataSourceImpl({required this.sharedPreferences});

  static const CACHED_THEME = 'CACHED_THEME';

  @override
  Future<void> setThemeMode(ThemeMode themeMode) {
    return sharedPreferences.setInt(CACHED_THEME, themeMode.index);
  }

  @override
  ThemeMode getThemeMode() {
    final int? themeModeIndex = sharedPreferences.getInt(CACHED_THEME);
    return themeModeIndex != null
        ? ThemeMode.values[themeModeIndex]
        : ThemeMode.system;
  }

  @override
  Future<Map<SafetyCategory, int>> getSafetyCategorySettings({
    int defaultSetting = 0,
  }) async {
    final Map<SafetyCategory, int> safetyCategorySettings = {};
    for (SafetyCategory category in SafetyCategory.values) {
      final int value =
          sharedPreferences.getInt(category.displayName) ?? defaultSetting;
      safetyCategorySettings[category] = value;
    }
    return safetyCategorySettings;
  }

  @override
  Future<void> setSafetyCategorySettings(
    Map<SafetyCategory, int> safetyCategorySettings, {
    int defaultSetting = 0,
  }) async {
    for (SafetyCategory category in safetyCategorySettings.keys) {
      final int value = safetyCategorySettings[category] ?? defaultSetting;
      await sharedPreferences.setInt(category.displayName, value);
    }
  }
}
