// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeminiResponse _$GeminiResponseFromJson(Map<String, dynamic> json) =>
    GeminiResponse(
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) => Candidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      promptFeedback: json['promptFeedback'] == null
          ? null
          : PromptFeedback.fromJson(
              json['promptFeedback'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeminiResponseToJson(GeminiResponse instance) =>
    <String, dynamic>{
      'candidates': instance.candidates,
      'promptFeedback': instance.promptFeedback,
    };
