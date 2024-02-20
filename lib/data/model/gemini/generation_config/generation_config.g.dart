// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerationConfig _$GenerationConfigFromJson(Map<String, dynamic> json) =>
    GenerationConfig(
      stopSequences: (json['stopSequences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxOutputTokens: json['maxOutputTokens'] as int?,
      topP: (json['topP'] as num?)?.toDouble(),
      topK: json['topK'] as int?,
    );

Map<String, dynamic> _$GenerationConfigToJson(GenerationConfig instance) =>
    <String, dynamic>{
      'stopSequences': instance.stopSequences,
      'temperature': instance.temperature,
      'maxOutputTokens': instance.maxOutputTokens,
      'topP': instance.topP,
      'topK': instance.topK,
    };
