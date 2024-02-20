import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:gemi/domain/entities/conversation.dart';

import '../../data/model/gemini/gemini_safety/safety_setting.dart';
import '../../data/model/gemini/generation_config/generation_config.dart';
import '../entities/prompt.dart';

abstract class GeminiRepository {
  bool get isGenerating;
  Stream<Either<Exception, Prompt?>> generatePrompt({
    String? text,
    List<String>? images,
    String? conversationId,
  });
  Stream<Either<Exception, Prompt?>> streamGeneratedPrompt({
    String? text,
    List<String>? images,
    String? conversationId,
  });

  Stream<Either<Exception, Prompt?>> streamGenerateChat(
    String text, {
    List<Prompt> chats = const [],
    String? conversationId,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  Future<Either<Exception, List<Conversation>>> getConversations();

  Future<Either<Exception, Conversation>> createConversation({
    required String name,
  });

  Future<Either<Exception, List<Prompt>>> getPrompts({
    required String conversationId,
  });

  Future<Either<Exception, void>> deleteConversation({
    required String conversationId,
  });

  Future<Either<Exception, Prompt?>> markGoodOrBadResponse({
    required Prompt prompt,
    required bool? isGoodResponse,
  });
}
