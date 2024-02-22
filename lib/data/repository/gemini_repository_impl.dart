import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:gemi/core/errors/data_source_exception.dart';
import 'package:gemi/core/optional.dart';
import 'package:gemi/core/utils/mutex.dart';
import 'package:gemi/data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source.dart';
import 'package:gemi/data/data_source/remote/remote_database/remote_database_impl.dart';
import 'package:gemi/data/model/conversation_model.dart';
import 'package:gemi/data/model/gemini/candidate/candidate.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_setting.dart';
import 'package:gemi/data/model/gemini/generation_config/generation_config.dart';
import 'package:gemi/data/model/prompt_model.dart';
import 'package:gemi/domain/entities/conversation.dart';
import 'package:gemi/domain/entities/prompt.dart';
import 'package:gemi/domain/repositories/data_storage_repository.dart';

import '../../core/errors/failure.dart';
import '../../domain/repositories/gemini_repository.dart';
import '../data_source/local/gemini_local_data_source/gemini_local_data_source.dart';
import '../model/gemini/content/content.dart';
import '../model/gemini/part/part.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final Mutex _mutex = Mutex();
  final GeminiLocalDataSource _localDataSource;
  final GeminiRemoteDataSource _remoteDataSource;
  final DataStorageRepository _dataStorageRepository;
  final GemiRemoteDatabase _remoteDatabase;
  final StreamController<Conversation> _conversationStreamController =
      StreamController.broadcast();

  @override
  Stream<Conversation> get conversationStream =>
      _conversationStreamController.stream;
  GeminiRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._dataStorageRepository,
    this._remoteDatabase,
  );

  @override
  bool get isGenerating => _mutex.isLocked;

  // Catch Error function
  Future<Either<Failure, T>> _catchError<T>(
    Future<T> Function() function,
  ) async {
    try {
      return Right(await function.call());
    } on RemoteDataSourceException catch (e) {
      return Left(Failure(message: e.message));
    } on LocalDataSourceException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      log(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Conversation> _createConversation({required String name}) async {
    final conversation = ConversationModel(
      userId: _remoteDatabase.userId,
      name: name,
    );
    await _remoteDatabase.insertConversation(conversation);
    await _localDataSource.insertConversation(conversation);
    _conversationStreamController.add(conversation);
    return conversation;
  }

  @override
  Stream<Either<Failure, Prompt?>> generatePrompt(
      {String? text, List<String>? images, String? conversationId}) async* {
    assert(
        text != null || (text != null && images != null && images.isNotEmpty));
    final lock = await _mutex.acquire();
    try {
      if (conversationId == null) {
        final conversation =
            await _createConversation(name: text ?? "Untitled Conversation");
        conversationId = conversation.id;
      }
      Candidate? candidate;
      final prompt = PromptModel.create(
        userId: _remoteDatabase.userId,
        conversationId: conversationId,
        text: text!,
        images: images,
        role: Role.user,
      );
      yield Right(prompt);
      // _localDataSource.insertPrompt(prompt);
      _catchError(() async {
        final res = await _remoteDatabase.insertPrompt(prompt);
        await _localDataSource.insertPrompt(res);
      });
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
        final prompt = PromptModel.create(
          userId: _remoteDatabase.userId,
          conversationId: conversationId,
          text: candidate.content?.parts?.first.text ?? '',
          role: Role.model,
        );
        yield Right(prompt);
        _catchError(() async {
          final res = await _remoteDatabase.insertPrompt(prompt);
          await _localDataSource.insertPrompt(res);
        });
      } else {
        yield const Left(Failure(message: 'No candidate'));
      }
    } catch (e) {
      yield Left(e as Failure);
    } finally {
      lock.release();
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      final List<ConversationModel> conversations =
          await _localDataSource.getConversations();
      if (conversations.isEmpty) {
        final remoteConversations = await _remoteDatabase.getConversations();
        await _localDataSource.insertConversations(remoteConversations);
        return Future.value(Right(remoteConversations));
      }

      return Future.value(Right(conversations));
    } catch (e) {
      return Future.value(Left(e as Failure));
    }
  }

  @override
  Stream<Either<Failure, Prompt?>> streamGeneratedPrompt(
      {String? text, List<String>? images, String? conversationId}) async* {
    final lock = await _mutex.acquire();
    if (conversationId == null) {
      final conversation =
          await _createConversation(name: text ?? "Untitled Conversation");
      conversationId = conversation.id;
    }
    final List<Uint8List>? imageBytes = images != null
        ? await Future.wait(images.map((e) => File(e).readAsBytes()))
        : null;

    final userPrompt = PromptModel.create(
      userId: _remoteDatabase.userId,
      conversationId: conversationId,
      text: text!,
      role: Role.user,
      images: images,
    );

    yield Right(userPrompt);
    _catchError(() async {
      final res = await _dataStorageRepository.uploadFiles(
          files: images!.map((e) => File(e)).toList(),
          path: 'conversations/$conversationId',
          bucketName: 'images');
      res.fold((l) => null, (r) async {
        final updatedPrompt = userPrompt.copyWith(images: Optional(r));
        await Future.wait([
          _localDataSource.insertPrompt(updatedPrompt),
          _remoteDatabase.insertPrompt(updatedPrompt),
        ]);
      });
    });
    if (images != null) {
      _dataStorageRepository
          .uploadFiles(
              files: images.map((e) => File(e)).toList(),
              path: 'conversations/$conversationId',
              bucketName: 'images')
          .then((value) {
        value.fold((l) => null, (r) {
          _localDataSource.updatePrompt(userPrompt.id, {
            "images": jsonEncode(r),
          });
        });
      }).catchError((e) => print(e));
    }

    String cache = "";
    var prompt = PromptModel.create(
      userId: _remoteDatabase.userId,
      conversationId: conversationId,
      text: cache,
      role: Role.model,
      isStreaming: true,
    );
    await for (var value in _remoteDataSource.streamGenerateContent(
      text,
      images: imageBytes,
    )) {
      cache += value.content?.parts?.first.text ?? "";
      prompt = prompt.copyWith(
        text: Optional(cache),
      );
      yield Right(prompt);
    }
    yield Right(prompt.copyWith(isStreaming: const Optional(false)));
    _catchError(() async {
      await Future.wait([
        _localDataSource.insertPrompt(prompt),
        _remoteDatabase.insertPrompt(prompt),
      ]);
    });
    lock.release();
  }

  @override
  Future<Either<Failure, List<Prompt>>> getPrompts(
      {required String conversationId}) async {
    try {
      List<PromptModel> prompts =
          await _localDataSource.getPrompts(conversationId);
      if (prompts.isEmpty) {
        prompts =
            await _remoteDatabase.getPrompts(conversationId: conversationId);
        _catchError(() => _localDataSource.insertPrompts(prompts));
      }
      return Future.value(Right(prompts));
    } catch (e) {
      return Future.value(Left(e as Failure));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(
      {required String conversationId}) {
    return _catchError(() async {
      await Future.wait([
        _remoteDatabase.deleteConversation(conversationId),
        _localDataSource.deleteConversation(conversationId),
      ]);
    });
  }

  @override
  Future<Either<Failure, Prompt?>> markGoodOrBadResponse(
      {required Prompt prompt, required bool? isGoodResponse}) async {
    return _catchError(() async {
      await _localDataSource.markPromptAsGoodResponse(
          prompt.id, isGoodResponse);
      return prompt.copyWith(isGoodResponse: Optional(isGoodResponse));
    });
  }

  @override
  Stream<Either<Failure, Prompt?>> streamGenerateChat(String text,
      {List<Prompt> chats = const [],
      String? conversationId,
      String? modelName,
      List<SafetySetting>? safetySettings,
      GenerationConfig? generationConfig}) async* {
    final lock = await _mutex.acquire();
    final prompts = [...chats];
    if (conversationId == null) {
      final conversation = await _createConversation(name: text);
      conversationId = conversation.id;
    }

    final prompt = PromptModel.create(
      userId: _remoteDatabase.userId,
      conversationId: conversationId,
      text: text,
      role: Role.user,
    );

    yield Right(prompt);
    _catchError(() async {
      final res = await _remoteDatabase.insertPrompt(prompt);
      await _localDataSource.insertPrompt(res);
    });

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

    final promptModel = PromptModel.create(
      userId: _remoteDatabase.userId,
      conversationId: conversationId,
      text: cache,
      role: Role.model,
      isStreaming: true,
    );

    await for (var value in stream) {
      cache += value.content?.parts?.first.text ?? "";
      final prompt = promptModel.copyWith(
        text: Optional(cache),
      );
      yield Right(prompt);
    }
    final finalPrompt =
        promptModel.copyWith(isStreaming: const Optional(false));
    yield Right(finalPrompt);
    _catchError(() async {
      await Future.wait([
        _localDataSource.insertPrompt(finalPrompt),
        _remoteDatabase.insertPrompt(finalPrompt),
      ]);
    });
    lock.release();
  }

  @override
  Future<Either<Failure, void>> clearConversations() {
    return _catchError(() async {
      await Future.wait([
        _remoteDatabase.clearConversations(),
        _localDataSource.clearConversations(),
      ]);
    });
  }
}
