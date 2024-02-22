import 'package:equatable/equatable.dart';
import 'package:gemi/core/optional.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

class Conversation extends Equatable {
  final String id;

  @JsonKey(name: 'user_id')
  final String? userId;

  final String name;

  @JsonKey(name: 'last_message_date')
  final DateTime? lastMessageDate;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  Conversation({
    String? id,
    required this.name,
    this.userId,
    this.lastMessageDate,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        lastMessageDate,
        createdAt,
      ];

  @override
  bool get stringify => true;

  Conversation copyWith({
    Optional<String> id = const Optional<String>.empty(),
    Optional<String?> userId = const Optional<String>.empty(),
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
    );
  }
}
