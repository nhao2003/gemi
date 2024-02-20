import 'package:flutter/services.dart';
import 'package:gemi/data/model/gemini/candidate/candidate.dart';

import '../../../model/gemini/content/content.dart';
import '../../../model/gemini/gemini_model/gemini_model.dart';
import '../../../model/gemini/gemini_safety/safety_setting.dart';
import '../../../model/gemini/generation_config/generation_config.dart';

abstract class GeminiRemoteDataSource {
  Future<List<GeminiModel>> listModels();
  Future<GeminiModel> info({required String model});
  Future<Candidate?> text(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  Future<List<List<num>?>?> batchEmbedContents(
    List<String> texts, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });
  Future<List<num>?> embedContent(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });
  Future<int?> countTokens(
    String text, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });
  Stream<Candidate> streamGenerateContent(
    String text, {
    List<Uint8List>? images,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  Stream<Candidate> streamChat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  Future<Candidate?> chat(
    List<Content> chats, {
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });

  Future<Candidate?> textAndImage({
    required String text,
    required List<Uint8List> images,
    String? modelName,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  });
}
