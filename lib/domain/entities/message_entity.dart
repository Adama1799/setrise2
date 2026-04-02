// lib/domain/entities/message_entity.dart
class MessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? mediaUrl;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
    this.mediaUrl,
  });
}
