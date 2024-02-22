import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/model/gemini/gemini_safety/safety_category.dart';

abstract class SettingRepository {
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
