// services/chat_service.dart
import '../models/chat_model.dart';

class ChatService {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> getMessages(String storeId) {
    // محاكاة رسائل قديمة
    return _messages.where((m) => m.storeId == storeId).toList();
  }

  void sendMessage(ChatMessage message) {
    _messages.add(message);
  }
}
