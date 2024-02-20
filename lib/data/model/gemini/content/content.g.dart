// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'parts': instance.parts,
      'role': _$RoleEnumMap[instance.role],
    };

const _$RoleEnumMap = {
  Role.user: 'user',
  Role.model: 'model',
};
