import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gemi/core/optional.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../data/model/gemini/content/content.dart';

@JsonSerializable()
class Prompt extends Equatable {
  final String id;

  @JsonKey(name: 'conversation_id')
  final String conversationId;

  @JsonKey(name: 'parent_id')
  final String? parentId;

  final Role role;

  @JsonKey()
  final List<String>? images;

  final String text;

  @JsonKey(name: 'is_good_response')
  final bool? isGoodResponse;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  final int version;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isStreaming;

  const Prompt({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.text,
    required this.createdAt,
    this.isGoodResponse,
    this.parentId,
    this.images,
    this.updatedAt,
    this.version = 0,
    this.isStreaming = false,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        parentId,
        role,
        text,
        createdAt,
        updatedAt,
        version,
      ];

  @override
  bool get stringify => true;

  Prompt copyWith({
    Optional<String> id = const Optional.empty(),
    Optional<String> conversationId = const Optional.empty(),
    Optional<String?> parentId = const Optional.empty(),
    Optional<Role> role = const Optional.empty(),
    Optional<String> text = const Optional.empty(),
    Optional<DateTime> createdAt = const Optional.empty(),
    Optional<DateTime?> updatedAt = const Optional.empty(),
    Optional<int> version = const Optional.empty(),
    Optional<bool> isStreaming = const Optional.empty(),
    Optional<bool?> isGoodResponse = const Optional.empty(),
    Optional<List<String>?> images = const Optional.empty(),
  }) {
    return Prompt(
      id: id.getOrElse(this.id),
      conversationId: conversationId.getOrElse(this.conversationId),
      parentId: parentId.getOrElse(this.parentId),
      role: role.getOrElse(this.role),
      text: text.getOrElse(this.text),
      createdAt: createdAt.getOrElse(this.createdAt),
      updatedAt: updatedAt.getOrElse(this.updatedAt),
      version: version.getOrElse(this.version),
      isStreaming: isStreaming.getOrElse(this.isStreaming),
      isGoodResponse: isGoodResponse.getOrElse(this.isGoodResponse),
      images: images.getOrElse(this.images),
    );
  }
}
