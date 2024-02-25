import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gemi/data/data_source/local/setting_local_data_source.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_category.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  @override
  Future<bool> setInt(String key, int value) {
    return super.noSuchMethod(
      Invocation.method(#setInt, [key, value]),
      returnValue: Future<bool>.value(true),
      returnValueForMissingStub: Future<bool>.value(true),
    );
  }

  @override
  int getInt(String key) {
    return super.noSuchMethod(
      Invocation.method(#getInt, [key]),
      returnValue: 0,
      returnValueForMissingStub: 0,
    );
  }
}

void main() {
  late SettingLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        SettingLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('SettingLocalDataSourceImpl', () {
    group('setThemeMode', () {
      test('should set the theme mode in shared preferences', () async {
        // Arrange
        const themeMode = ThemeMode.dark;

        // Act
        await dataSource.setThemeMode(themeMode);

        // Assert
        verify(mockSharedPreferences.setInt(
            SettingLocalDataSourceImpl.CACHED_THEME, themeMode.index));
      });
    });

    group('getThemeMode', () {
      test('should return the saved theme mode from shared preferences', () {
        // Arrange
        final themeModeIndex = ThemeMode.light.index;
        when(mockSharedPreferences
                .getInt(SettingLocalDataSourceImpl.CACHED_THEME))
            .thenReturn(themeModeIndex);

        // Act
        final result = dataSource.getThemeMode();

        // Assert
        expect(result, ThemeMode.light);
      });

      test('should return system theme mode if no saved theme mode found', () {
        // Arrange
        when(mockSharedPreferences
            .getInt(SettingLocalDataSourceImpl.CACHED_THEME));

        // Act
        final result = dataSource.getThemeMode();

        // Assert
        expect(result, ThemeMode.system);
      });
    });

    group('getSafetyCategorySettings', () {
      test(
          'should return the saved safety category settings from shared preferences',
          () async {
        // Arrange
        const defaultSetting = 0;
        final safetyCategorySettings = {
          SafetyCategory.dangerous: 1,
          SafetyCategory.harassment: 2,
          SafetyCategory.hateSpeech: 3,
          SafetyCategory.sexuallyExplicit: 4,
        };
        for (final entry in safetyCategorySettings.entries) {
          when(mockSharedPreferences.getInt(entry.key.displayName))
              .thenReturn(entry.value);
        }

        // Act
        final result = await dataSource.getSafetyCategorySettings(
            defaultSetting: defaultSetting);

        // Assert
        expect(result, safetyCategorySettings);
      });

      test(
          'should return default safety category settings if no saved settings found',
          () async {
        // Arrange
        const defaultSetting = 0;
        final safetyCategorySettings = {
          SafetyCategory.dangerous: defaultSetting,
          SafetyCategory.harassment: defaultSetting,
          SafetyCategory.hateSpeech: defaultSetting,
          SafetyCategory.sexuallyExplicit: defaultSetting,
        };
        for (final category in SafetyCategory.values) {
          when(mockSharedPreferences.getInt(category.displayName));
        }

        // Act
        final result = await dataSource.getSafetyCategorySettings(
            defaultSetting: defaultSetting);

        // Assert
        expect(result, safetyCategorySettings);
      });
    });

    group('setSafetyCategorySettings', () {
      test('should set the safety category settings in shared preferences',
          () async {
        // Arrange
        const defaultSetting = 0;
        final safetyCategorySettings = {
          SafetyCategory.dangerous: 1,
          SafetyCategory.harassment: 2,
          SafetyCategory.hateSpeech: 3,
          SafetyCategory.sexuallyExplicit: 4,
        };
        for (final entry in safetyCategorySettings.entries) {
          when(mockSharedPreferences.setInt(entry.key.displayName, entry.value))
              .thenAnswer((_) async => Future.value(true));
        }
        // Act
        await dataSource.setSafetyCategorySettings(safetyCategorySettings,
            defaultSetting: defaultSetting);

        // Assert
        for (final entry in safetyCategorySettings.entries) {
          log(entry.key.displayName);
          verify(
            mockSharedPreferences.setInt(entry.key.displayName, entry.value),
          );
        }
      });
    });
  });
}
