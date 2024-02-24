import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/conversation.dart';
part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel extends Conversation {
  ConversationModel({
    required super.id,
    required super.userId,
    required super.name,
    super.lastMessageDate,
    super.createdAt,
  });
  @override
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonMap = Map<String, dynamic>.from(json);
    if (jsonMap['images'] != null) {
      if (jsonMap['images'] is String) {
        jsonMap['images'] = jsonDecode(json['images']).cast<String>();
      }
    }
    return _$ConversationModelFromJson(jsonMap);
  }

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

  factory ConversationModel.create({
    required String id,
    required String userId,
    required String name,
  }) {
    return ConversationModel(
      id: id,
      userId: userId,
      name: name,
    );
  }
}
