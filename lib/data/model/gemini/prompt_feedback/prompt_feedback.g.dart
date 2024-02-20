// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptFeedback _$PromptFeedbackFromJson(Map<String, dynamic> json) =>
    PromptFeedback(
      safetyRatings: (json['safetyRatings'] as List<dynamic>?)
          ?.map((e) => SafetyRating.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromptFeedbackToJson(PromptFeedback instance) =>
    <String, dynamic>{
      'safetyRatings': instance.safetyRatings,
    };
