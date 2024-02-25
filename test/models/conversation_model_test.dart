import 'package:test/test.dart';
import 'package:gemi/data/model/conversation_model.dart';

void main() {
  group('ConversationModel', () {
    test('fromJson() should return a valid ConversationModel instance', () {
      final json = {
        'id': '123',
        'user_id': 'user123',
        'name': 'Test Conversation',
        'last_message_date': '2024-02-21 13:56:13.647758+00',
        'created_at': '2024-02-21 13:56:44.59792+00',
      };

      final result = ConversationModel.fromJson(json);

      expect(result, isA<ConversationModel>());
      expect(result.id, '123');
      expect(result.userId, 'user123');
      expect(result.name, 'Test Conversation');
      expect(result.lastMessageDate,
          DateTime.parse('2024-02-21 13:56:13.647758+00'));
      expect(result.createdAt, DateTime.parse('2024-02-21 13:56:44.59792+00'));
    });

    test('toJson() should return a valid JSON map', () {
      final conversation = ConversationModel.create(
        id: '123',
        userId: 'user123',
        name: 'Test Conversation',
      );
      final result = conversation.toJson();
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], '123');
      expect(result['user_id'], 'user123');
      expect(result['name'], 'Test Conversation');
    });
  });
}
