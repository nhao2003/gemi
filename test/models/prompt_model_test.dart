import 'dart:convert';

import 'package:gemi/core/optional.dart';
import 'package:gemi/data/model/gemini/content/content.dart';
import 'package:test/test.dart';
import 'package:gemi/data/model/prompt_model.dart';

void main() {
  group('PromptModel', () {
    test('fromJson() should return a valid PromptModel instance', () {
      final json = {
        'user_id': 'user123',
        'conversation_id': 'conv123',
        'role': 'user',
        'text': 'Test Prompt',
        'created_at': '2024-02-21 13:56:44.59792+00',
        'id': 'prompt123',
        'updated_at': '2024-02-21 13:56:44.59792+00',
        'is_good_response': false,
        'images': ['image1.jpg', 'image2.jpg'],
      };

      final result = PromptModel.fromJson(json);

      expect(result, isA<PromptModel>());
      expect(result.userId, 'user123');
      expect(result.conversationId, 'conv123');
      expect(result.role, Role.user);
      expect(result.text, 'Test Prompt');
      expect(result.createdAt, DateTime.parse('2024-02-21 13:56:44.59792+00'));
      expect(result.id, 'prompt123');
      expect(result.updatedAt, DateTime.parse('2024-02-21 13:56:44.59792+00'));
      expect(result.isStreaming, false);
      expect(result.isGoodResponse, false);
      expect(result.images, ['image1.jpg', 'image2.jpg']);
    });
    test('toJson() should return a valid JSON map', () {
      final prompt = PromptModel.create(
        userId: 'user123',
        conversationId: 'conv123',
        role: Role.user,
        text: 'Test Prompt',
        images: const ['image1.jpg', 'image2.jpg'],
        isStreaming: true,
      );
      final localJson = prompt.toJson();
      expect(localJson, isA<Map<String, dynamic>>());
      expect(localJson['user_id'], 'user123');
      expect(localJson['conversation_id'], 'conv123');
      expect(localJson['role'], 'user');
      expect(localJson['text'], 'Test Prompt');
      expect(localJson['created_at'], isNotNull);
      expect(localJson['id'], isNotNull);
      expect(localJson['updated_at'], isNull);
      expect(localJson['images'], isA<String>());
      expect(localJson['is_good_response'], isNull);
    });
    test('toJson(isRemoteJson: true) should return a valid JSON map', () {
      final prompt = PromptModel.create(
        userId: 'user123',
        conversationId: 'conv123',
        role: Role.user,
        text: 'Test Prompt',
        images: const ['image1.jpg', 'image2.jpg'],
        isStreaming: true,
      );
      final remoteJson = prompt.toJson(isRemoteJson: true);
      expect(remoteJson, isA<Map<String, dynamic>>());
      expect(remoteJson['user_id'], 'user123');
      expect(remoteJson['conversation_id'], 'conv123');
      expect(remoteJson['role'], 'user');
      expect(remoteJson['text'], 'Test Prompt');
      expect(remoteJson['created_at'], isNotNull);
      expect(remoteJson['id'], isNotNull);
      expect(remoteJson['updated_at'], isNull);
      expect(remoteJson['images'], ['image1.jpg', 'image2.jpg']);
      expect(remoteJson['is_good_response'], isNull);
    });
    test(
        'copyWith() should return a new PromptModel instance with updated values',
        () {
      final prompt = PromptModel.create(
        userId: 'user123',
        conversationId: 'conv123',
        role: Role.user,
        text: 'Test Prompt',
        images: const ['image1.jpg', 'image2.jpg'],
        isStreaming: true,
      );

      final updatedPrompt = prompt.copyWith(
        text: const Optional('Updated Prompt'),
        isGoodResponse: const Optional(true),
      );

      expect(updatedPrompt, isA<PromptModel>());
      expect(updatedPrompt.userId, prompt.userId);
      expect(updatedPrompt.conversationId, prompt.conversationId);
      expect(updatedPrompt.role, prompt.role);
      expect(updatedPrompt.text, 'Updated Prompt');
      expect(updatedPrompt.createdAt, prompt.createdAt);
      expect(updatedPrompt.id, prompt.id);
      expect(updatedPrompt.updatedAt, prompt.updatedAt);
      expect(updatedPrompt.isStreaming, prompt.isStreaming);
      expect(updatedPrompt.isGoodResponse, true);
      expect(updatedPrompt.images, prompt.images);
    });
  });
}
