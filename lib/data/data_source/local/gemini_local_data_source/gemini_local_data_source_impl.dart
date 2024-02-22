import 'package:gemi/core/errors/data_source_exception.dart';
import 'package:gemi/data/data_source/local/gemini_local_data_source/gemini_local_data_source.dart';
import 'package:gemi/data/model/conversation_model.dart';
import 'package:gemi/data/model/prompt_model.dart';
import 'package:gemi/domain/entities/conversation.dart';
import 'package:gemi/domain/entities/prompt.dart';
import 'package:sqflite/sqflite.dart';

class GeminiLocalDataSourceImpl implements GeminiLocalDataSource {
  final Database database;

  GeminiLocalDataSourceImpl({required this.database});
  Future<T> _catchError<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw LocalDataSourceException(message: e.toString());
    }
  }

  @override
  Future<List<PromptModel>> getPrompts(String conversationId) async {
    return _catchError(() async {
      final data = await database.query(
        'prompts',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        orderBy: 'created_at ASC',
      );

      return data.map((e) => PromptModel.fromJson(e)).toList();
    });
  }

  @override
  Future<void> insertPrompt(PromptModel prompt,
      {ConflictAlgorithm? conflictAlgorithm}) {
    return _catchError(() async {
      final json = prompt.toJson();
      await database.insert(
        'prompts',
        json,
        conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> insertConversation(ConversationModel conversation) async {
    return _catchError(() async {
      final json = conversation.toJson();
      await database.insert(
        'conversations',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    return _catchError(() async {
      final data = await database.query(
        'conversations',
        orderBy: 'last_message_date DESC',
      );

      return data.map((e) => ConversationModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Map<String, dynamic>> getConversation(String conversationId) async {
    return _catchError(() async {
      final List<Map<String, dynamic>> conversations = await database.query(
        'conversations',
        where: 'id = ?',
        whereArgs: [conversationId],
      );

      return conversations.first;
    });
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    return _catchError(() async {
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
    });
  }

  @override
  Future<void> updateConversation(ConversationModel conversation) async {
    return _catchError(() async {
      await database.update(
        'conversations',
        conversation.toJson(),
        where: 'id = ?',
        whereArgs: [conversation.id],
      );
    });
  }

  @override
  Future<int> updatePrompt(String id, Map<String, dynamic> data) async {
    return _catchError(() async {
      final value = await database.update(
        'prompts',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
      return value;
    });
  }

  @override
  Future<int> markPromptAsGoodResponse(String id, bool? isGoodResponse) {
    return _catchError(() => updatePrompt(id, {
          'is_good_response': isGoodResponse == null
              ? null
              : isGoodResponse
                  ? 1
                  : 0
        }));
  }

  @override
  Future<void> insertPrompts(List<PromptModel> prompts,
      {ConflictAlgorithm? conflictAlgorithm}) {
    return _catchError(() async {
      final batch = database.batch();
      for (var prompt in prompts) {
        batch.insert(
          'prompts',
          prompt.toJson(),
          conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> insertConversations(List<ConversationModel> conversations) {
    return _catchError(() async {
      final batch = database.batch();
      for (var conversation in conversations) {
        batch.insert(
          'conversations',
          conversation.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> clearConversations() {
    return _catchError(() async {
      await database.delete('conversations');
      await database.delete('prompts');
    });
  }
}
