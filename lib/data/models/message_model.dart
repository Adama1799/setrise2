// lib/data/models/message_model.dart
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required String id,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String receiverId,
    required String content,
    required DateTime timestamp,
    required bool isRead,
    required String? mediaUrl,
  }) : super(
    id: id,
    senderId: senderId,
    senderName: senderName,
    senderAvatar: senderAvatar,
    receiverId: receiverId,
    content: content,
    timestamp: timestamp,
    isRead: isRead,
    mediaUrl: mediaUrl,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'User',
      senderAvatar: json['senderAvatar'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
      mediaUrl: json['mediaUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'senderAvatar': senderAvatar,
    'receiverId': receiverId,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
    'mediaUrl': mediaUrl,
  };

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    String? mediaUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }
}
