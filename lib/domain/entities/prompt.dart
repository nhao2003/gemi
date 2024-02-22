import 'package:equatable/equatable.dart';
import 'package:gemi/core/optional.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/gemini/content/content.dart';

@JsonSerializable()
class Prompt extends Equatable {
  late final String id;

  @JsonKey(name: 'conversation_id')
  final String conversationId;

  @JsonKey(name: 'user_id')
  final String userId;

  final Role role;

  @JsonKey()
  final List<String>? images;

  final String text;

  @JsonKey(name: 'is_good_response')
  final bool? isGoodResponse;

  @JsonKey(name: 'created_at')
  late DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isStreaming;

  Prompt({
    String? id,
    required this.conversationId,
    required this.role,
    required this.text,
    DateTime? createdAt,
    required this.userId,
    this.isGoodResponse,
    this.images,
    this.updatedAt,
    this.isStreaming = false,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        role,
        text,
        createdAt,
        updatedAt,
        isStreaming,
        isGoodResponse,
        images,
      ];

  @override
  bool get stringify => true;

  Prompt copyWith({
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
    return Prompt(
      id: id.getOrElse(this.id),
      conversationId: conversationId.getOrElse(this.conversationId),
      role: role.getOrElse(this.role),
      text: text.getOrElse(this.text),
      createdAt: createdAt.getOrElse(this.createdAt),
      updatedAt: updatedAt.getOrElse(this.updatedAt),
      isStreaming: isStreaming.getOrElse(this.isStreaming),
      isGoodResponse: isGoodResponse.getOrElse(this.isGoodResponse),
      images: images.getOrElse(this.images),
      userId: userId.getOrElse(this.userId),
    );
  }
}
