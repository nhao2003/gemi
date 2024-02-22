import 'package:gemi/data/model/conversation_model.dart';
import 'package:gemi/data/model/prompt_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class GemiRemoteDatabase {
  String get userId;
  Future<PromptModel> insertPrompt(PromptModel prompt);
  Future<List<PromptModel>> getPrompts({required String conversationId});
  Future<ConversationModel> insertConversation(ConversationModel conversation);
  Future<List<ConversationModel>> getConversations();
  Future<void> deleteConversation(String conversationId);

  Future<void> clearConversations();
}

class GemiRemoteDatabaseImpl implements GemiRemoteDatabase {
  final SupabaseClient _client;

  GemiRemoteDatabaseImpl(this._client);

  @override
  String get userId => _client.auth.currentUser!.id;

  @override
  Future<PromptModel> insertPrompt(PromptModel prompt) async {
    final response = await _client
        .from('prompts')
        .insert(prompt.toJson(isRemoteJson: true))
        .select();
    return PromptModel.fromJson(response.first);
  }

  @override
  Future<List<PromptModel>> getPrompts({
    required String conversationId,
  }) async {
    var response = await _client.rest
        .from('prompts')
        .select()
        .eq('conversation_id', conversationId)
        .eq('user_id', userId);
    return response.map((e) => PromptModel.fromJson(e)).toList();
  }

  @override
  Future<ConversationModel> insertConversation(
      ConversationModel conversation) async {
    final response = await _client
        .from('conversations')
        .insert(conversation.toJson())
        .select();
    return ConversationModel.fromJson(response.first);
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    var response =
        await _client.rest.from('conversations').select().eq('user_id', userId);
    return response.map((e) => ConversationModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await _client
        .from('conversations')
        .delete()
        .eq('id', conversationId)
        .eq('user_id', userId);
  }

  @override
  Future<void> clearConversations() {
    return _client.from('conversations').delete().eq('user_id', userId);
  }
}
