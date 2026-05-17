here// lib/presentation/screens/shop/material_shop/screens/chat/chat_screen.dart
//
// FIX: chatService.sendMessage(msg) → chatService.sendMessage(storeId, senderId, text)
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/chat_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String storeId, storeName;
  const ChatScreen({
    Key? key,
    required this.storeId,
    required this.storeName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgCtrl = TextEditingController();
  final chatService = ChatService();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    messages = List.from(chatService.getMessages(widget.storeId));
  }

  @override
  void dispose() {
    msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = msgCtrl.text.trim();
    if (text.isEmpty) return;

    // ✅ FIX: sendMessage يحتاج 3 معاملات: storeId, senderId, text
    chatService.sendMessage(widget.storeId, 'user', text);

    setState(() {
      // نعيد جلب الرسائل من الخدمة لضمان التزامن
      messages = List.from(chatService.getMessages(widget.storeId));
      msgCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeName,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isMe
                          ? const Color(0xFFFF7643)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color:
                            msg.isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontFamily: 'Inter'),
                    ),
                    style: const TextStyle(fontFamily: 'Inter'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
