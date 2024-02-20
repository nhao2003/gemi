import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:gemi/core/optional.dart';
import 'package:gemi/core/utils/mutex.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source.dart';
import 'package:gemi/data/model/conversation_model.dart';
import 'package:gemi/data/model/gemini/candidate/candidate.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_setting.dart';
import 'package:gemi/data/model/gemini/generation_config/generation_config.dart';
import 'package:gemi/data/model/prompt_model.dart';
import 'package:gemi/domain/entities/conversation.dart';
import 'package:gemi/domain/entities/prompt.dart';

import '../../domain/repositories/gemini_repository.dart';
import '../data_source/local/gemini_local_data_source.dart';
import '../model/gemini/content/content.dart';
import '../model/gemini/part/part.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final GeminiLocalDataSourceImpl _localDataSource;
  final GeminiRemoteDataSource _remoteDataSource;
  final Mutex _mutex = Mutex();
  GeminiRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  bool get isGenerating => _mutex.isLocked;

  genareId() {
    return Random().nextInt(100000).toString();
  }

  @override
  Future<Either<Exception, Conversation>> createConversation(
      {required String name}) {
    final conversation =
        ConversationModel(id: genareId(), userId: 'userId', name: name);

    try {
      _localDataSource.insertConversation(conversation);
      return Future.value(Right(conversation));
    } catch (e) {
      return Future.value(Left(e as Exception));
    }
  }

  @override
  Stream<Either<Exception, Prompt?>> generatePrompt(
      {String? text, List<String>? images, String? conversationId}) async* {
    assert(
        text != null || (text != null && images != null && images.isNotEmpty));
    conversationId ??= genareId();
    final lock = await _mutex.acquire();
    try {
      Candidate? candidate;
      final prompt = PromptModel(
        id: genareId(),
        conversationId: conversationId!,
        text: text!,
        images: images,
        createdAt: DateTime.now(),
        role: Role.user,
        updatedAt: null,
      );
      yield Right(prompt);
      _localDataSource.insertPrompt(prompt);
      if (images != null) {
        List<Future<Uint8List>> futures = [];
        for (var image in images) {
          futures.add(File(image).readAsBytes());
        }

        candidate = await _remoteDataSource.textAndImage(
          text: text,
          images: await Future.wait(futures),
        );
      } else {
        candidate = await _remoteDataSource.text(text);
      }

      if (candidate != null) {
        final prompt = PromptModel(
          id: genareId(),
          conversationId: conversationId!,
          text: candidate.content?.parts?.first.text ?? '',
          createdAt: DateTime.now(),
          role: Role.model,
          updatedAt: null,
        );
        yield Right(prompt);
        _localDataSource.insertPrompt(prompt);
      } else {
        yield Left(Exception('No candidate'));
      }
    } catch (e) {
      yield Left(e as Exception);
    } finally {
      lock.release();
    }
  }

  @override
  Future<Either<Exception, List<Conversation>>> getConversations() async {
    try {
      final conversations = await _localDataSource.getConversations();
      return Future.value(Right(conversations));
    } catch (e) {
      return Future.value(Left(e as Exception));
    }
  }

  @override
  Stream<Either<Exception, Prompt?>> streamGeneratedPrompt(
      {String? text, List<String>? images, String? conversationId}) async* {
    final lock = await _mutex.acquire();
    if (conversationId == null) {
      conversationId = genareId();
      _localDataSource.insertConversation(ConversationModel(
        id: conversationId!,
        userId: 'userId',
        name: text ?? "Untitled Conversation",
      ));
    }
    final List<Uint8List>? imageBytes = images != null
        ? await Future.wait(images.map((e) => File(e).readAsBytes()))
        : null;

    final userPrompt = PromptModel(
      id: genareId(),
      conversationId: conversationId!,
      text: text!,
      createdAt: DateTime.now(),
      role: Role.user,
      isStreaming: false,
      images: images,
    );

    yield Right(userPrompt);
    _localDataSource.insertPrompt(userPrompt);

    String cache = "";
    String id = genareId();
    DateTime createdAt = DateTime.now();

    await for (var value in _remoteDataSource.streamGenerateContent(
      text,
      images: imageBytes,
    )) {
      cache += value.content?.parts?.first.text ?? "";
      print("Stream: ${cache.length}");
      final prompt = PromptModel(
        id: id,
        conversationId: conversationId,
        text: cache,
        createdAt: createdAt,
        role: Role.model,
        isStreaming: true,
      );
      yield Right(prompt);
    }
    final prompt = PromptModel(
      id: id,
      conversationId: conversationId!,
      text: cache,
      createdAt: createdAt,
      role: Role.model,
      isStreaming: false,
    );
    yield Right(prompt);
    _localDataSource.insertPrompt(prompt);
    lock.release();
  }

  @override
  Future<Either<Exception, List<Prompt>>> getPrompts(
      {required String conversationId}) async {
    // return await _localDataSource.getPrompts(conversationId);
    try {
      final prompts = await _localDataSource.getPrompts(conversationId);
      return Future.value(Right(prompts));
    } catch (e) {
      return Future.value(Left(e as Exception));
    }
  }

  @override
  Future<Either<Exception, void>> deleteConversation(
      {required String conversationId}) {
    try {
      _localDataSource.deleteConversation(conversationId);
      return Future.value(const Right(null));
    } catch (e) {
      return Future.value(Left(e as Exception));
    }
  }

  @override
  Future<Either<Exception, Prompt?>> markGoodOrBadResponse(
      {required Prompt prompt, required bool? isGoodResponse}) async {
    try {
      await _localDataSource.markPromptAsGoodResponse(
          prompt.id, isGoodResponse);

      return Future.value(
          Right(prompt.copyWith(isGoodResponse: Optional(isGoodResponse))));
    } catch (e) {
      return Future.value(Left(Exception(e.toString())));
    }
  }

  @override
  Stream<Either<Exception, Prompt?>> streamGenerateChat(String text,
      {List<Prompt> chats = const [],
      String? conversationId,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async* {
    final lock = await _mutex.acquire();
    final prompts = [...chats];
    if (conversationId == null) {
      conversationId = genareId();
      await _localDataSource.insertConversation(ConversationModel(
        id: conversationId!,
        userId: 'userId',
        name: text,
      ));
    }

    final prompt = PromptModel(
      id: genareId(),
      conversationId: conversationId,
      text: text,
      createdAt: DateTime.now(),
      role: Role.user,
      updatedAt: null,
    );

    yield Right(prompt);
    _localDataSource.insertPrompt(prompt);

    prompts.add(prompt);

    final stream = _remoteDataSource.streamChat(
      prompts
          .map((e) => Content(parts: [
                Part(
                  text: e.text,
                ),
              ], role: e.role))
          .toList(),
      modelName: modelName,
      safetySettings: safetySettings,
      generationConfig: generationConfig,
    );
    String cache = "";
    String id = genareId();
    await for (var value in stream) {
      cache += value.content?.parts?.first.text ?? "";
      final prompt = PromptModel(
        id: id,
        conversationId: conversationId,
        text: cache,
        createdAt: DateTime.now(),
        role: Role.model,
        updatedAt: null,
        isStreaming: true,
      );
      yield Right(prompt);
    }
    final finalPrompt = PromptModel(
      id: id,
      conversationId: conversationId,
      text: cache,
      createdAt: DateTime.now(),
      role: Role.model,
      updatedAt: null,
      isStreaming: false,
    );

    _localDataSource.insertPrompt(finalPrompt);
    yield Right(finalPrompt);
    lock.release();
  }
}
