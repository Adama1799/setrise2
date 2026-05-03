import 'package:flutter/cupertino.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'chat_message.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String storeName, storeId;
  const ChatScreen({super.key, required this.storeName, required this.storeId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _messages = ChatMessage.getMockMessages();
  final _scrollCtrl = ScrollController();

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    final msg = ChatMessage(id: DateTime.now().toString(), text: _msgCtrl.text.trim(), isMe: true, timestamp: DateTime.now());
    setState(() { _messages.add(msg); _msgCtrl.clear(); });
    Future.delayed(const Duration(milliseconds: 100), () => _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut));
    Future.delayed(const Duration(seconds: 1), () {
      final reply = ChatMessage(id: DateTime.now().toString(), text: 'Thank you! We will reply soon.', isMe: false, timestamp: DateTime.now());
      setState(() => _messages.add(reply));
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() { _msgCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.white,
        leading: CupertinoNavigationBarBackButton(color: AppColors.black, onPressed: () => Navigator.pop(context)),
        middle: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.shop, shape: BoxShape.circle), child: const Icon(CupertinoIcons.person_2, color: AppColors.black, size: 18)),
          const SizedBox(width: 8),
          Text(widget.storeName, style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
      ),
      child: Column(children: [
        Expanded(child: ListView.builder(controller: _scrollCtrl, padding: const EdgeInsets.all(12), itemCount: _messages.length, itemBuilder: (_, i) => MessageBubble(message: _messages[i]))),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))), child: Row(children: [
          Expanded(child: CupertinoTextField(controller: _msgCtrl, placeholder: 'Message...', style: const TextStyle(color: AppColors.black), decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10))),
          const SizedBox(width: 8),
          CupertinoButton(padding: EdgeInsets.zero, child: Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.shop, shape: BoxShape.circle), child: const Icon(CupertinoIcons.arrow_up, color: AppColors.black, size: 22)), onPressed: _send),
        ])),
      ]),
    );
  }
}
