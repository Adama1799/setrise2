// lib/presentation/providers/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/chat/get_conversations_usecase.dart';
import '../../domain/usecases/chat/get_messages_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/mark_as_read_usecase.dart';
import '../../data/models/message_model.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatState {
  final List<MessageModel> conversations;
  final List<MessageModel> messages;
  final String? selectedConversationId;
  final bool isLoading;
  final bool isSendingMessage;
  final String? error;

  ChatState({
    required this.conversations,
    required this.messages,
    this.selectedConversationId,
    required this.isLoading,
    required this.isSendingMessage,
    this.error,
  });

  ChatState copyWith({
    List<MessageModel>? conversations,
    List<MessageModel>? messages,
    String? selectedConversationId,
    bool? isLoading,
    bool? isSendingMessage,
    String? error,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      selectedConversationId: selectedConversationId ?? this.selectedConversationId,
      isLoading: isLoading ?? this.isLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      error: error ?? this.error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final _getConversationsUsecase = getIt<GetConversationsUsecase>();
  final _getMessagesUsecase = getIt<GetMessagesUsecase>();
  final _sendMessageUsecase = getIt<SendMessageUsecase>();
  final _markAsReadUsecase = getIt<MarkAsReadUsecase>();

  ChatNotifier()
      : super(ChatState(
          conversations: _generateMockConversations(),
          messages: [],
          isLoading: false,
          isSendingMessage: false,
        ));

  static List<MessageModel> _generateMockConversations() {
    return List.generate(10, (i) => MessageModel(
      id: '$i',
      senderId: 'user_$i',
      senderName: 'User ${i + 1}',
      senderAvatar: 'https://i.pravatar.cc/150?img=$i',
      receiverId: 'me',
      content: 'Hey, how are you?',
      timestamp: DateTime.now().subtract(Duration(hours: i)),
      isRead: i < 5,
      mediaUrl: null,
    ));
  }

  Future<void> loadConversations(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getConversationsUsecase(userId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (conversations) {
        state = state.copyWith(
          conversations: conversations.cast<MessageModel>(),
          isLoading: false,
        );
      },
    );
  }

  Future<void> loadMessages(String conversationId) async {
    state = state.copyWith(
      isLoading: true,
      selectedConversationId: conversationId,
      error: null,
    );
    final result = await _getMessagesUsecase(conversationId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (messages) {
        state = state.copyWith(
          messages: messages.cast<MessageModel>(),
          isLoading: false,
        );
      },
    );
  }

  Future<void> sendMessage(String receiverId, String content) async {
    state = state.copyWith(isSendingMessage: true);
    final result = await _sendMessageUsecase(receiverId, content);
    result.fold(
      (failure) {
        state = state.copyWith(
          isSendingMessage: false,
          error: failure.message,
        );
      },
      (message) {
        state = state.copyWith(
          messages: [...state.messages, message as MessageModel],
          isSendingMessage: false,
        );
      },
    );
  }

  Future<void> markAsRead(String messageId) async {
    await _markAsReadUsecase(messageId);
  }
}
