import 'package:equatable/equatable.dart';
import 'package:gemi/core/optional.dart';
import 'package:json_annotation/json_annotation.dart';

class Conversation extends Equatable {
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String name;

  @JsonKey(name: 'last_message_date')
  final DateTime? lastMessageDate;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const Conversation({
    required this.id,
    required this.userId,
    required this.name,
    this.lastMessageDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, userId, name, lastMessageDate, createdAt, updatedAt];

  @override
  bool get stringify => true;

  // Conversation copyWith({
  //   String? id,
  //   String? userId,
  //   String? name,
  //   DateTime? lastMessageDate,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  // }) {
  //   return Conversation(
  //     id: id ?? this.id,
  //     userId: userId ?? this.userId,
  //     name: name ?? this.name,
  //     lastMessageDate: lastMessageDate ?? this.lastMessageDate,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //   );
  // }

  Conversation copyWith({
    Optional<String> id = const Optional<String>.empty(),
    Optional<String> userId = const Optional<String>.empty(),
    Optional<String> name = const Optional<String>.empty(),
    Optional<DateTime?> lastMessageDate = const Optional<DateTime?>.empty(),
    Optional<DateTime?> createdAt = const Optional<DateTime?>.empty(),
    Optional<DateTime?> updatedAt = const Optional<DateTime?>.empty(),
  }) {
    return Conversation(
      id: id.getOrElse(this.id),
      userId: userId.getOrElse(this.userId),
      name: name.getOrElse(this.name),
      lastMessageDate: lastMessageDate.getOrElse(this.lastMessageDate),
      createdAt: createdAt.getOrElse(this.createdAt),
      updatedAt: updatedAt.getOrElse(this.updatedAt),
    );
  }
}
