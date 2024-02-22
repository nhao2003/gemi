import 'package:flutter/material.dart';
import 'package:gemi/data/data_source/local/setting_local_data_source.dart';

import 'package:gemi/data/model/gemini/gemini_safety/safety_category.dart';

import '../../domain/repositories/setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  SettingLocalDataSource settingLocalDataSource;

  SettingRepositoryImpl({required this.settingLocalDataSource});
  @override
  Future<Map<SafetyCategory, int>> getSafetyCategorySettings(
      {int defaultSetting = 0}) {
    return settingLocalDataSource.getSafetyCategorySettings(
        defaultSetting: defaultSetting);
  }

  @override
  ThemeMode getThemeMode() {
    return settingLocalDataSource.getThemeMode();
  }

  @override
  Future<void> setSafetyCategorySettings(
      Map<SafetyCategory, int> safetyCategorySettings,
      {int defaultSetting = 0}) {
    return settingLocalDataSource.setSafetyCategorySettings(
        safetyCategorySettings,
        defaultSetting: defaultSetting);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) {
    return settingLocalDataSource.setThemeMode(themeMode);
  }
}
