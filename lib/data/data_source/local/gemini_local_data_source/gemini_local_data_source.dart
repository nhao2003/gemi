import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/conversation.dart';
import '../../../../domain/entities/prompt.dart';
import '../../../model/conversation_model.dart';
import '../../../model/prompt_model.dart';

abstract class GeminiLocalDataSource {
  Future<List<PromptModel>> getPrompts(String conversationId);
  Future<void> insertPrompt(PromptModel prompt,
      {ConflictAlgorithm? conflictAlgorithm});
  Future<void> insertPrompts(List<PromptModel> prompts,
      {ConflictAlgorithm? conflictAlgorithm});
  Future<int> updatePrompt(String id, Map<String, dynamic> data);
  Future<void> insertConversation(ConversationModel conversation);
  Future<void> insertConversations(List<ConversationModel> conversations);
  Future<List<ConversationModel>> getConversations(String userId);
  Future<Map<String, dynamic>> getConversation(String conversationId);
  Future<void> deleteConversation(String conversationId);
  Future<void> updateConversation(ConversationModel conversation);

  Future<int> markPromptAsGoodResponse(String id, bool? isGoodResponse);

  Future<void> clearConversations();
}
