import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:gemi/domain/entities/conversation.dart';

import '../../core/errors/failure.dart';
import '../../data/model/gemini/gemini_safety/safety_setting.dart';
import '../../data/model/gemini/generation_config/generation_config.dart';
import '../entities/prompt.dart';

abstract class GeminiRepository {
  bool get isGenerating;
  Stream<Conversation> get conversationStream;
  Stream<Either<Failure, Prompt?>> generatePrompt({
    String? text,
    List<String>? images,
    String? conversationId,
  });
  Stream<Either<Failure, Prompt?>> streamGeneratedPrompt({
    String? text,
    List<String>? images,
    String? conversationId,
  });

  Stream<Either<Failure, Prompt?>> streamGenerateChat(
    String text, {
    List<Prompt> chats = const [],
    String? conversationId,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  Future<Either<Failure, List<Conversation>>> getConversations();

  Future<Either<Failure, List<Prompt>>> getPrompts({
    required String conversationId,
  });

  Future<Either<Failure, void>> deleteConversation({
    required String conversationId,
  });

  Future<Either<Failure, Prompt?>> markGoodOrBadResponse({
    required Prompt prompt,
    required bool? isGoodResponse,
  });

  Future<Either<Failure, void>> clearConversations();
}
