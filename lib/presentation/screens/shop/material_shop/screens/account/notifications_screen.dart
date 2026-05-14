import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';

enum NotifType { order, chat, promo, review, system }

class ShopNotif {
  final String id, title, body;
  final NotifType type;
  final DateTime time;
  bool isRead;
  ShopNotif({required this.id, required this.title, required this.body, required this.type, required this.time, this.isRead = false});
}

class NotifNotifier extends StateNotifier<List<ShopNotif>> {
  NotifNotifier() : super(_seed);
  void markRead(String id) { state = [for (final n in state) if (n.id == id) (n..isRead = true) else n]; }
  void markAllRead() { state = [for (final n in state) n..isRead = true]; }
  void delete(String id) { state = state.where((n) => n.id != id).toList(); }
  void clearAll() => state = [];
  int get unreadCount => state.where((n) => !n.isRead).length;
}

final notifProvider = StateNotifierProvider<NotifNotifier, List<ShopNotif>>((_) => NotifNotifier());

final _seed = [
  ShopNotif(id: 'n1', title: 'Order Confirmed ✅',        body: 'Your order ORD-28471 has been confirmed and is being prepared.',           type: NotifType.order,  time: DateTime.now().subtract(const Duration(minutes: 5))),
  ShopNotif(id: 'n2', title: 'New Message 💬',             body: 'TechZone Store replied: "Yes! Black version is available."',               type: NotifType.chat,   time: DateTime.now().subtract(const Duration(minutes: 32))),
  ShopNotif(id: 'n3', title: 'Flash Sale ⚡',              body: 'Up to 40% off Gaming accessories. Ends in 2 hours!',                       type: NotifType.promo,  time: DateTime.now().subtract(const Duration(hours: 1)),  isRead: true),
  ShopNotif(id: 'n4', title: 'Order Shipped 🚚',           body: 'Your order is on the way. Tracking: TRK-183920.',                          type: NotifType.order,  time: DateTime.now().subtract(const Duration(hours: 3)),  isRead: true),
  ShopNotif(id: 'n5', title: 'Review Helpful 👍',          body: '12 people found your review of "SteelSeries Product 1" helpful.',          type: NotifType.review, time: DateTime.now().subtract(const Duration(hours: 5))),
  ShopNotif(id: 'n6', title: 'Welcome to SetRize Shop 🎉', body: 'Use WELCOME20 for 20% off your first order!',                              type: NotifType.system, time: DateTime.now().subtract(const Duration(days: 1)), isRead: true),
  ShopNotif(id: 'n7', title: 'Price Drop Alert 📉',        body: 'An item in your wishlist dropped to \$67.00. Grab it before it\'s gone!',  type: NotifType.promo,  time: DateTime.now().subtract(const Duration(days: 2))),
  ShopNotif(id: 'n8', title: 'Review Your Purchase',       body: 'How was your "RGB Gaming Keyboard"? Leave a review and help others.',      type: NotifType.review, time: DateTime.now().subtract(const Duration(days: 3)), isRead: true),
];

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifs = ref.watch(notifProvider);
    final notifier = ref.read(notifProvider.notifier);
    final unread = notifier.unreadCount;
    final now = DateTime.now();
    final today   = notifs.where((n) => n.time.day == now.day && n.time.month == now.month).toList();
    final earlier = notifs.where((n) => !(n.time.day == now.day && n.time.month == now.month)).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Row(children: [
          Text('Notifications', style: AppTextStyles.headline3),
          if (unread > 0) ...[
            const SizedBox(width: AppDimensions.sm),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.badgeCartBg, borderRadius: BorderRadius.circular(99)), child: Text('$unread', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w800, fontFamily: 'Inter'))),
          ],
        ]),
        actions: [
          if (notifs.isNotEmpty) PopupMenuButton<String>(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            onSelected: (v) { if (v == 'read') notifier.markAllRead(); if (v == 'clear') notifier.clearAll(); },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'read', child: Row(children: [const Icon(Icons.done_all, size: 18, color: AppColors.ctaPrimaryBg), const SizedBox(width: AppDimensions.sm), Text('Mark all read', style: AppTextStyles.bodySmall)])),
              PopupMenuItem(value: 'clear', child: Row(children: [const Icon(Icons.delete_sweep_outlined, size: 18, color: AppColors.error), const SizedBox(width: AppDimensions.sm), Text('Clear all', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error))])),
            ],
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md), child: const Icon(Icons.more_horiz, color: AppColors.textPrimary)),
          ),
        ],
      ),
      body: notifs.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.textQuaternary),
              SizedBox(height: AppDimensions.md),
              Text('No notifications', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textTertiary, fontFamily: 'Inter')),
              SizedBox(height: AppDimensions.xs),
              Text('You\'re all caught up!', style: TextStyle(color: AppColors.textQuaternary, fontFamily: 'Inter')),
            ]))
          : ListView(padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm), children: [
              if (today.isNotEmpty) ...[
                _Label('Today'),
                ...today.map((n) => _Tile(notif: n, onTap: () => notifier.markRead(n.id), onDismiss: () => notifier.delete(n.id))),
              ],
              if (earlier.isNotEmpty) ...[
                _Label('Earlier'),
                ...earlier.map((n) => _Tile(notif: n, onTap: () => notifier.markRead(n.id), onDismiss: () => notifier.delete(n.id))),
              ],
              const SizedBox(height: AppDimensions.xxl),
            ]),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, AppDimensions.xs),
    child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontWeight: FontWeight.w700)),
  );
}

class _Tile extends StatelessWidget {
  final ShopNotif notif;
  final VoidCallback onTap, onDismiss;
  const _Tile({required this.notif, required this.onTap, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final color = _color(notif.type);
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) { HapticFeedback.lightImpact(); onDismiss(); },
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: AppDimensions.lg), color: AppColors.error.withOpacity(0.1), child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 24)),
      child: GestureDetector(
        onTap: () { HapticFeedback.selectionClick(); onTap(); },
        child: AnimatedContainer(duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: 3),
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: notif.isRead ? Colors.white : color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
            border: notif.isRead ? null : Border.all(color: color.withOpacity(0.15)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle), child: Icon(_icon(notif.type), size: 22, color: color)),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(notif.title, style: AppTextStyles.bodySmall.copyWith(fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800, color: AppColors.textPrimary))),
                if (!notif.isRead) Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              ]),
              const SizedBox(height: 3),
              Text(notif.body, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(_fmtTime(notif.time), style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary, fontSize: 11)),
            ])),
          ]),
        ),
      ),
    );
  }

  IconData _icon(NotifType t) { switch (t) { case NotifType.order: return Icons.receipt_long_rounded; case NotifType.chat: return Icons.chat_bubble_rounded; case NotifType.promo: return Icons.local_offer_rounded; case NotifType.review: return Icons.star_rounded; case NotifType.system: return Icons.campaign_rounded; } }
  Color _color(NotifType t) { switch (t) { case NotifType.order: return AppColors.ctaPrimaryBg; case NotifType.chat: return AppColors.success; case NotifType.promo: return AppColors.warning; case NotifType.review: return AppColors.ratingFilled; case NotifType.system: return const Color(0xFF9C27B0); } }
  String _fmtTime(DateTime t) { final d = DateTime.now().difference(t); if (d.inMinutes < 1) return 'Just now'; if (d.inMinutes < 60) return '${d.inMinutes}m ago'; if (d.inHours < 24) return '${d.inHours}h ago'; return '${d.inDays}d ago'; }
}
