// lib/presentation/screens/shop/chat_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ChatScreen extends StatefulWidget {
  final String storeName;
  final String storeId;

  const ChatScreen({
    super.key,
    required this.storeName,
    required this.storeId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = ChatMessage.getMockMessages();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      isMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate reply
    Future.delayed(const Duration(seconds: 1), () {
      final replyMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Thank you for your message! We will get back to you soon.',
        isMe: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(replyMessage);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.shop,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store,
                color: AppColors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storeName,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neonGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey2,
                        ),
                        filled: true,
                        fillColor: AppColors.grey.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.shop,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.shop,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store,
                color: AppColors.black,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppColors.shop
                    : AppColors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: message.isMe ? AppColors.black : AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: AppTextStyles.caption.copyWith(
                      color: message.isMe
                          ? AppColors.black.withOpacity(0.6)
                          : AppColors.grey2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  static List<ChatMessage> getMockMessages() {
    return [
      ChatMessage(
        id: '1',
        text: 'Hello! I am interested in your products.',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        id: '2',
        text: 'Hi there! Thank you for your interest. Which product would you like to know more about?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      ChatMessage(
        id: '3',
        text: 'The wireless headphones look great. Do you have them in black?',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      ChatMessage(
        id: '4',
        text: 'Yes, we have them in black, white, and blue. Black is our most popular color!',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 23)),
      ),
      ChatMessage(
        id: '5',
        text: 'Perfect! What is the shipping time to Algiers?',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ChatMessage(
        id: '6',
        text: 'Shipping to Algiers usually takes 2-3 business days. We also offer express delivery for an additional fee.',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
    ];
  }
}
