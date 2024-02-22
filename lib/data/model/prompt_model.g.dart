// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptModel _$PromptModelFromJson(Map<String, dynamic> json) => PromptModel(
      userId: json['user_id'] as String,
      conversationId: json['conversation_id'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      text: json['text'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: json['id'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isGoodResponse: json['is_good_response'] as bool?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PromptModelToJson(PromptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'user_id': instance.userId,
      'role': _$RoleEnumMap[instance.role]!,
      'images': instance.images,
      'text': instance.text,
      'is_good_response': instance.isGoodResponse,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$RoleEnumMap = {
  Role.user: 'user',
  Role.model: 'model',
};
