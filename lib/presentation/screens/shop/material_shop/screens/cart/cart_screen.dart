import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/chat_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/chat_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String storeId, storeName, storeEmoji;
  final ProductModel? sharedProduct;
  const ChatScreen({Key? key, required this.storeId, required this.storeName, this.storeEmoji = '🏪', this.sharedProduct}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _ctrl   = TextEditingController();
  final _scroll = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    ref.read(chatProvider.notifier).openConversation(widget.storeId, widget.storeName, widget.storeEmoji);
    // Auto-send shared product message
    if (widget.sharedProduct != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(chatProvider.notifier).sendMessage(widget.storeId, '🛍️ I\'m interested in: ${widget.sharedProduct!.name} (\$${widget.sharedProduct!.price.toStringAsFixed(2)})');
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    ref.read(chatProvider.notifier).sendMessage(widget.storeId, text);
    _ctrl.clear();
    setState(() => _isTyping = false);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _showAttachMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, margin: const EdgeInsets.only(bottom: AppDimensions.lg), decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(2))),
          Text('Share', style: AppTextStyles.headline3),
          const SizedBox(height: AppDimensions.lg),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _AttachBtn(icon: Icons.image_outlined,          label: 'Image',   color: AppColors.ctaPrimaryBg,  onTap: () { Navigator.pop(context); _sendSpecial('📷 [Image shared]'); }),
            _AttachBtn(icon: Icons.shopping_bag_outlined,   label: 'Product', color: AppColors.success,        onTap: () { Navigator.pop(context); _sendSpecial('🛍️ [Product card shared]'); }),
            _AttachBtn(icon: Icons.local_offer_outlined,    label: 'Offer',   color: AppColors.warning,        onTap: () { Navigator.pop(context); _sendSpecial('🏷️ [Special offer shared]'); }),
            _AttachBtn(icon: Icons.location_on_outlined,    label: 'Location',color: AppColors.error,          onTap: () { Navigator.pop(context); _sendSpecial('📍 [Location shared]'); }),
          ]),
          const SizedBox(height: AppDimensions.lg),
        ]),
      ),
    );
  }

  void _sendSpecial(String text) {
    ref.read(chatProvider.notifier).sendMessage(widget.storeId, text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(chatProvider);
    final conv = conversations.where((c) => c.storeId == widget.storeId).firstOrNull;
    final messages = conv?.messages ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        titleSpacing: 0,
        title: Row(children: [
          Stack(children: [
            CircleAvatar(backgroundColor: AppColors.backgroundPrimary, radius: 18, child: Text(widget.storeEmoji, style: const TextStyle(fontSize: 20))),
            Positioned(bottom: 0, right: 0, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)))),
          ]),
          const SizedBox(width: AppDimensions.sm),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.storeName, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
            Text('Online now', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
          ]),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_outlined, color: AppColors.ctaPrimaryBg), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call_outlined, color: AppColors.ctaPrimaryBg), onPressed: () {}),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: messages.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(widget.storeEmoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: AppDimensions.md),
                  Text(widget.storeName, style: AppTextStyles.headline3),
                  const SizedBox(height: AppDimensions.xs),
                  Text('Send a message to get started', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                  const SizedBox(height: AppDimensions.xl),
                  // Quick starters
                  Wrap(spacing: AppDimensions.sm, runSpacing: AppDimensions.sm, children: [
                    '👋 Hello!', '💬 Is this available?', '💰 Best price?', '🚚 When shipped?'
                  ].map((q) => GestureDetector(
                    onTap: () { _ctrl.text = q; _send(); },
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusFull), border: const Border.fromBorderSide(BorderSide(color: AppColors.borderSubtle))), child: Text(q, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
                  )).toList()),
                ]))
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final prev = i > 0 ? messages[i - 1] : null;
                    final showDate = prev == null || prev.timestamp.day != msg.timestamp.day;
                    final showAvatar = !msg.isMe && (i == messages.length - 1 || messages[i + 1].isMe);
                    return Column(children: [
                      if (showDate) Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                        child: Row(children: [const Expanded(child: Divider(color: AppColors.borderSubtle)), Padding(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm), child: Text(_fmtDate(msg.timestamp), style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary))), const Expanded(child: Divider(color: AppColors.borderSubtle))]),
                      ),
                      _Bubble(msg: msg, emoji: widget.storeEmoji, showAvatar: showAvatar, isLast: i == messages.length - 1),
                    ]);
                  },
                ),
        ),

        // Input bar
        Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -2))]),
          padding: EdgeInsets.fromLTRB(AppDimensions.sm, AppDimensions.sm, AppDimensions.sm, MediaQuery.of(context).padding.bottom + AppDimensions.sm),
          child: Row(children: [
            IconButton(onPressed: _showAttachMenu, icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.ctaPrimaryBg, size: 26)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 2),
                child: TextField(
                  controller: _ctrl, maxLines: 4, minLines: 1,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                  onChanged: (v) => setState(() => _isTyping = v.trim().isNotEmpty),
                  decoration: InputDecoration(hintText: 'Message...', hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textQuaternary), border: InputBorder.none, isDense: true),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.xs),
            GestureDetector(
              onTap: _isTyping ? _send : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40, height: 40,
                decoration: BoxDecoration(color: _isTyping ? AppColors.ctaPrimaryBg : AppColors.backgroundTertiary, shape: BoxShape.circle),
                child: Icon(Icons.send_rounded, size: 18, color: _isTyping ? Colors.white : AppColors.textQuaternary),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  String _fmtDate(DateTime t) {
    final now = DateTime.now();
    if (t.day == now.day && t.month == now.month) return 'Today';
    if (t.day == now.day - 1) return 'Yesterday';
    return '${t.day}/${t.month}/${t.year}';
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  final String emoji;
  final bool showAvatar, isLast;
  const _Bubble({required this.msg, required this.emoji, required this.showAvatar, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isSpecial = msg.text.startsWith('📷') || msg.text.startsWith('🛍️') || msg.text.startsWith('🏷️') || msg.text.startsWith('📍');
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) SizedBox(width: 36, child: showAvatar ? CircleAvatar(backgroundColor: AppColors.backgroundPrimary, radius: 16, child: Text(emoji, style: const TextStyle(fontSize: 16))) : null),
          if (!msg.isMe) const SizedBox(width: 6),
          Column(crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: isSpecial ? AppDimensions.sm : 10),
              decoration: BoxDecoration(
                color: msg.isMe ? AppColors.ctaPrimaryBg : Colors.white,
                borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(msg.isMe ? 18 : 4), bottomRight: Radius.circular(msg.isMe ? 4 : 18)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: isSpecial
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: (msg.isMe ? Colors.white : AppColors.ctaPrimaryBg).withOpacity(0.15), borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Text(msg.text.substring(0, 2), style: const TextStyle(fontSize: 18))),
                    const SizedBox(width: AppDimensions.sm),
                    Flexible(child: Text(msg.text.substring(3), style: AppTextStyles.bodySmall.copyWith(color: msg.isMe ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600))),
                  ])
                : Text(msg.text, style: AppTextStyles.bodySmall.copyWith(color: msg.isMe ? Colors.white : AppColors.textPrimary)),
            ),
            const SizedBox(height: 2),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_fmtTime(msg.timestamp), style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary, fontSize: 10)),
              if (msg.isMe) ...[
                const SizedBox(width: 3),
                // Read receipts ✓✓
                Icon(isLast ? Icons.done_all : Icons.done, size: 12, color: isLast ? AppColors.ctaPrimaryBg : AppColors.textQuaternary),
              ],
            ]),
          ]),
          if (msg.isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  String _fmtTime(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _AttachBtn extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _AttachBtn({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 52, height: 52, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
      const SizedBox(height: 6),
      Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
    ]),
  );
}
