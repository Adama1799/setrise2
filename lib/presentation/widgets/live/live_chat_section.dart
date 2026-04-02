// lib/presentation/widgets/live/live_chat_section.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/live_stream_model.dart';

class LiveChatSection extends StatefulWidget {
  final LiveStreamModel stream;

  const LiveChatSection({
    super.key,
    required this.stream,
  });

  @override
  State<LiveChatSection> createState() => _LiveChatSectionState();
}

class _LiveChatSectionState extends State<LiveChatSection> {
  final _chatController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'username': '@user1',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'message': 'Amazing stream! 🔥',
      'isPinned': false,
    },
    {
      'username': '@user2',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'message': 'Love this content!',
      'isPinned': false,
    },
    {
      'username': '@streamer',
      'avatar': 'https://i.pravatar.cc/150?img=0',
      'message': 'Thanks for watching!',
      'isPinned': true,
    },
    {
      'username': '@user3',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'message': 'Great job guys ❤️',
      'isPinned': false,
    },
  ];

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[_messages.length - 1 - index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(msg['avatar']),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                msg['username'],
                                style: AppTypography.labelSmall,
                              ),
                              if (msg['isPinned'])
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.push_pin,
                                    size: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            msg['message'],
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(color: AppColors.border),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    hintText: 'Send a message...',
                    hintStyle: AppTypography.caption,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  style: AppTypography.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_chatController.text.isNotEmpty) {
                    setState(() {
                      _messages.add({
                        'username': '@you',
                        'avatar': 'https://i.pravatar.cc/150?img=0',
                        'message': _chatController.text,
                        'isPinned': false,
                      });
                      _chatController.clear();
                    });
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
