// screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/chat_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String storeId, storeName;
  const ChatScreen({Key? key, required this.storeId, required this.storeName}) : super(key: key);

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
    messages = chatService.getMessages(widget.storeId);
  }

  void _send() {
    if (msgCtrl.text.trim().isEmpty) return;
    final msg = ChatMessage(
      id: DateTime.now().toString(),
      storeId: widget.storeId,
      senderId: 'user',
      text: msgCtrl.text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    );
    setState(() {
      messages.add(msg);
      msgCtrl.clear();
    });
    chatService.sendMessage(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.storeName, style: const TextStyle(fontFamily: 'Inter'))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isMe ? const Color(0xFFFF7643) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text, style: TextStyle(fontFamily: 'Inter', color: msg.isMe ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
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
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
