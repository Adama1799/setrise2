// lib/presentation/screens/shop/chat/widgets/message_bubble.dart
import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/chat/chat_message.dart';  // ← استيراد مطلق

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.shop, shape: BoxShape.circle), child: const Icon(CupertinoIcons.person_2, color: AppColors.black, size: 18)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? AppColors.shop : AppColors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(message.text, style: TextStyle(color: message.isMe ? AppColors.black : AppColors.white)),
                const SizedBox(height: 4),
                Text('${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2,'0')}',
                    style: TextStyle(color: message.isMe ? AppColors.black.withOpacity(0.6) : AppColors.grey2, fontSize: 11)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
