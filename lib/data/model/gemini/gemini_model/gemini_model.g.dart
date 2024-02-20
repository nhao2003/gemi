// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeminiModel _$GeminiModelFromJson(Map<String, dynamic> json) => GeminiModel(
      name: json['name'] as String?,
      version: json['version'] as String?,
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      inputTokenLimit: json['inputTokenLimit'] as int?,
      outputTokenLimit: json['outputTokenLimit'] as int?,
      supportedGenerationMethods:
          (json['supportedGenerationMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      topP: (json['topP'] as num?)?.toDouble(),
      topK: json['topK'] as int?,
    );

Map<String, dynamic> _$GeminiModelToJson(GeminiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'displayName': instance.displayName,
      'description': instance.description,
      'inputTokenLimit': instance.inputTokenLimit,
      'outputTokenLimit': instance.outputTokenLimit,
      'supportedGenerationMethods': instance.supportedGenerationMethods,
      'temperature': instance.temperature,
      'topP': instance.topP,
      'topK': instance.topK,
    };
