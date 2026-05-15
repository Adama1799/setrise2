import 'package:flutter/material.dart';
import '../models/chat_model.dart';

/// ChatService — خدمة المحادثات
/// ملاحظة: استخدم chat_provider.dart (Riverpod) في الشاشات الجديدة
class ChatService extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _conversations = {};

  List<ChatMessage> getMessages(String storeId) =>
      List.unmodifiable(_conversations[storeId] ?? []);

  List<String> get activeStoreIds => _conversations.keys.toList();

  void sendMessage(String storeId, String senderId, String text) {
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      storeId: storeId,
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );
    _conversations.putIfAbsent(storeId, () => []);
    _conversations[storeId]!.add(msg);
    notifyListeners();
  }

  void receiveMessage(String storeId, String senderId, String text) {
    final msg = ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}r',
      storeId: storeId,
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
      isMe: false,
    );
    _conversations.putIfAbsent(storeId, () => []);
    _conversations[storeId]!.add(msg);
    notifyListeners();
  }

  void clearConversation(String storeId) {
    _conversations.remove(storeId);
    notifyListeners();
  }

  int unreadCount(String storeId) =>
      (_conversations[storeId] ?? []).where((m) => !m.isMe).length;
}
