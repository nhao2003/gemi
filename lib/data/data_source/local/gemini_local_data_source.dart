import 'package:gemi/data/model/conversation_model.dart';
import 'package:gemi/data/model/prompt_model.dart';
import 'package:gemi/domain/entities/conversation.dart';
import 'package:gemi/domain/entities/prompt.dart';
import 'package:sqflite/sqflite.dart';

abstract class GeminiLocalDataSource {
  Future<List<Prompt>> getPrompts(String conversationId);
  Future<void> insertPrompt(PromptModel prompt);
  Future<int> updatePrompt(String id, Map<String, dynamic> data);
  Future<void> insertConversation(ConversationModel conversation);
  Future<List<Conversation>> getConversations();
  Future<Map<String, dynamic>> getConversation(String conversationId);
  Future<void> deleteConversation(String conversationId);
  Future<void> updateConversation(ConversationModel conversation);

  Future<int> markPromptAsGoodResponse(String id, bool? isGoodResponse);
}

class GeminiLocalDataSourceImpl implements GeminiLocalDataSource {
  final Database database;

  GeminiLocalDataSourceImpl({required this.database});

  @override
  Future<List<Prompt>> getPrompts(String conversationId) async {
    final data = await database.query(
      'prompts',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'created_at ASC',
    );

    return data.map((e) => PromptModel.fromJson(e)).toList();
  }

  @override
  Future<void> insertPrompt(PromptModel prompt) async {
    final json = prompt.toJson();
    await database.insert(
      'prompts',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertConversation(ConversationModel conversation) async {
    await database.insert(
      'conversations',
      conversation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Conversation>> getConversations() async {
    final data = await database.query(
      'conversations',
      orderBy: 'last_message_date DESC',
    );

    return data.map((e) => ConversationModel.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> getConversation(String conversationId) async {
    final List<Map<String, dynamic>> conversations = await database.query(
      'conversations',
      where: 'id = ?',
      whereArgs: [conversationId],
    );

    return conversations.first;
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await Future.wait([
      database.delete(
        'prompts',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
      ),
      database.delete(
        'conversations',
        where: 'id = ?',
        whereArgs: [conversationId],
      ),
    ]);
  }

  @override
  Future<void> updateConversation(ConversationModel conversation) async {
    await database.update(
      'conversations',
      conversation.toJson(),
      where: 'id = ?',
      whereArgs: [conversation.id],
    );
  }

  @override
  Future<int> updatePrompt(String id, Map<String, dynamic> data) async {
    try {
      final value = await database.update(
        'prompts',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
      return value;
    } catch (e) {
      return Future.value(0);
    }
  }

  @override
  Future<int> markPromptAsGoodResponse(String id, bool? isGoodResponse) {
    return updatePrompt(id, {
      'is_good_response': isGoodResponse == null
          ? null
          : isGoodResponse
              ? 1
              : 0
    });
  }
}
