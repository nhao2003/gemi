// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SafetySetting _$SafetySettingFromJson(Map<String, dynamic> json) =>
    SafetySetting(
      category: $enumDecode(_$SafetyCategoryEnumMap, json['category']),
      threshold: $enumDecode(_$SafetyThresholdEnumMap, json['threshold']),
    );

Map<String, dynamic> _$SafetySettingToJson(SafetySetting instance) =>
    <String, dynamic>{
      'category': _$SafetyCategoryEnumMap[instance.category]!,
      'threshold': _$SafetyThresholdEnumMap[instance.threshold]!,
    };

const _$SafetyCategoryEnumMap = {
  SafetyCategory.harassment: 'HARM_CATEGORY_HARASSMENT',
  SafetyCategory.hateSpeech: 'HARM_CATEGORY_HATE_SPEECH',
  SafetyCategory.sexuallyExplicit: 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
  SafetyCategory.dangerous: 'HARM_CATEGORY_DANGEROUS_CONTENT',
};

const _$SafetyThresholdEnumMap = {
  SafetyThreshold.blockNone: 'BLOCK_NONE',
  SafetyThreshold.blockOnlyHigh: 'BLOCK_ONLY_HIGH',
  SafetyThreshold.blockMediumAndAbove: 'BLOCK_MEDIUM_AND_ABOVE',
  SafetyThreshold.blockLowAndAbove: 'BLOCK_LOW_AND_ABOVE',
  SafetyThreshold.harmBlockThresholdUnspecified:
      'HARM_BLOCK_THRESHOLD_UNSPECIFIED',
};
