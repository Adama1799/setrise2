// models/chat_model.dart
class ChatMessage {
  final String id, storeId, senderId, text;
  final DateTime timestamp;
  final bool isMe; // هل المرسل هو المستخدم الحالي؟
  ChatMessage({
    required this.id,
    required this.storeId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isMe = false,
  });
}
