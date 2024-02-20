import 'dart:convert';

import 'package:gemi/domain/entities/prompt.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gemini/content/content.dart';
part 'prompt_model.g.dart';

@JsonSerializable()
class PromptModel extends Prompt {
  const PromptModel({
    required super.id,
    required super.conversationId,
    required super.role,
    required super.text,
    required super.createdAt,
    super.isGoodResponse,
    super.parentId,
    super.images,
    super.updatedAt,
    super.version,
    super.isStreaming,
  });

  @override
  factory PromptModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonMap = Map<String, dynamic>.from(json);
    if (jsonMap['is_good_response'] != null) {
      if (jsonMap['is_good_response'] is int) {
        jsonMap['is_good_response'] = (json['is_good_response'] == 1);
      }
    }

    if (jsonMap['images'] != null) {
      if (jsonMap['images'] is String) {
        jsonMap['images'] = jsonDecode(jsonMap['images']);
      }
    }
    return _$PromptModelFromJson(jsonMap);
  }

  Map<String, dynamic> toJson() {
    final json = _$PromptModelToJson(this);
    if (json['images'] != null) {
      json['images'] = jsonEncode(json['images']);
    }
    return json;
  }
}
