import 'dart:convert';

import 'package:gemi/core/optional.dart';
import 'package:gemi/domain/entities/prompt.dart';
import 'package:json_annotation/json_annotation.dart';

import 'gemini/content/content.dart';
part 'prompt_model.g.dart';

@JsonSerializable()
class PromptModel extends Prompt {
  PromptModel({
    required super.userId,
    required super.conversationId,
    required super.role,
    required super.text,
    required super.createdAt,
    super.id,
    super.updatedAt,
    super.isStreaming,
    super.isGoodResponse,
    super.images,
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

  Map<String, dynamic> toJson({
    bool isRemoteJson = false,
  }) {
    final json = _$PromptModelToJson(this);
    if (json['images'] != null && !isRemoteJson) {
      json['images'] = jsonEncode(json['images']);
    }
    return json;
  }

  factory PromptModel.create({
    required String userId,
    required String conversationId,
    required Role role,
    required String text,
    String? parentId,
    List<String>? images,
    bool? isStreaming,
  }) {
    return PromptModel(
      userId: userId,
      conversationId: conversationId,
      role: role,
      text: text,
      isGoodResponse: null,
      images: images,
      createdAt: DateTime.now(),
      isStreaming: isStreaming ?? false,
    );
  }

  @override
  PromptModel copyWith({
    Optional<String> id = const Optional.empty(),
    Optional<String> userId = const Optional.empty(),
    Optional<String> conversationId = const Optional.empty(),
    Optional<Role> role = const Optional.empty(),
    Optional<String> text = const Optional.empty(),
    Optional<DateTime> createdAt = const Optional.empty(),
    Optional<DateTime?> updatedAt = const Optional.empty(),
    Optional<bool> isStreaming = const Optional.empty(),
    Optional<bool?> isGoodResponse = const Optional.empty(),
    Optional<List<String>?> images = const Optional.empty(),
  }) {
    return PromptModel(
      id: id.getOrElse(this.id),
      userId: userId.getOrElse(this.userId),
      conversationId: conversationId.getOrElse(this.conversationId),
      role: role.getOrElse(this.role),
      text: text.getOrElse(this.text),
      createdAt: createdAt.getOrElse(this.createdAt),
      updatedAt: updatedAt.getOrElse(this.updatedAt),
      isStreaming: isStreaming.getOrElse(this.isStreaming),
      isGoodResponse: isGoodResponse.getOrElse(this.isGoodResponse),
      images: images.getOrElse(this.images),
    );
  }
}
