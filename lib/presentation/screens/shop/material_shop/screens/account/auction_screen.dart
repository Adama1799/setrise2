import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';

// ─── Models ──────────────────────────────────────────────────
class BidEntry {
  final String user;
  final double amount;
  final DateTime time;
  const BidEntry({required this.user, required this.amount, required this.time});
}

class AuctionItem {
  final String id, name, emoji, imageUrl, description;
  final double startBid;
  final Duration timeLeft;
  final bool isHot;
  List<BidEntry> bids;

  AuctionItem({required this.id, required this.name, required this.emoji, required this.imageUrl, required this.description, required this.startBid, required this.timeLeft, this.isHot = false, List<BidEntry>? bids})
      : bids = bids ?? [];

  double get currentBid => bids.isEmpty ? startBid : bids.last.amount;
  int get totalBids => bids.length;
}

// ─── Provider ────────────────────────────────────────────────
class AuctionNotifier extends StateNotifier<List<AuctionItem>> {
  AuctionNotifier() : super(_seed);

  void placeBid(String itemId, double amount, String user) {
    state = [
      for (final item in state)
        if (item.id == itemId) AuctionItem(
          id: item.id, name: item.name, emoji: item.emoji, imageUrl: item.imageUrl,
          description: item.description, startBid: item.startBid, timeLeft: item.timeLeft, isHot: item.isHot,
          bids: [...item.bids, BidEntry(user: user, amount: amount, time: DateTime.now())],
        )
        else item,
    ];
  }
}

final auctionProvider = StateNotifierProvider<AuctionNotifier, List<AuctionItem>>((_) => AuctionNotifier());

final _seed = [
  AuctionItem(id: 'a1', name: 'SteelSeries Arctis Pro Headset', emoji: '🎧', imageUrl: 'https://picsum.photos/600/600?random=10', description: 'Premium wireless gaming headset with Hi-Res audio and ClearCast mic.', startBid: 100, timeLeft: const Duration(hours: 2, minutes: 14), isHot: true, bids: [
    BidEntry(user: 'Ahmed_K', amount: 110, time: DateTime.now().subtract(const Duration(hours: 1, minutes: 50))),
    BidEntry(user: 'Sara_M', amount: 130, time: DateTime.now().subtract(const Duration(hours: 1))),
    BidEntry(user: 'Omar_T', amount: 155, time: DateTime.now().subtract(const Duration(minutes: 40))),
    BidEntry(user: 'Lina_R', amount: 185, time: DateTime.now().subtract(const Duration(minutes: 10))),
  ]),
  AuctionItem(id: 'a2', name: 'Mechanical Gaming Keyboard RGB', emoji: '⌨️', imageUrl: 'https://picsum.photos/600/600?random=11', description: 'Compact TKL layout with Cherry MX switches and per-key RGB lighting.', startBid: 50, timeLeft: const Duration(hours: 5, minutes: 40), bids: [
    BidEntry(user: 'GamePro_X', amount: 60, time: DateTime.now().subtract(const Duration(hours: 3))),
    BidEntry(user: 'KeyMaster', amount: 80, time: DateTime.now().subtract(const Duration(hours: 1))),
    BidEntry(user: 'NightOwl9', amount: 92, time: DateTime.now().subtract(const Duration(minutes: 20))),
  ]),
  AuctionItem(id: 'a3', name: 'Limited Edition Gaming Mouse', emoji: '🖱️', imageUrl: 'https://picsum.photos/600/600?random=12', description: '25K DPI optical sensor, 8 programmable buttons, ultralight 58g design.', startBid: 40, timeLeft: const Duration(minutes: 45), isHot: true, bids: [
    BidEntry(user: 'ClickPro', amount: 45, time: DateTime.now().subtract(const Duration(minutes: 30))),
    BidEntry(user: 'MouseGod', amount: 58, time: DateTime.now().subtract(const Duration(minutes: 15))),
    BidEntry(user: 'Swift_Ali', amount: 67, time: DateTime.now().subtract(const Duration(minutes: 3))),
  ]),
  AuctionItem(id: 'a4', name: '4K Gaming Monitor 144Hz', emoji: '🖥️', imageUrl: 'https://picsum.photos/600/600?random=13', description: 'IPS panel, 1ms response time, G-Sync compatible, HDR600 certified.', startBid: 200, timeLeft: const Duration(hours: 1, minutes: 5), bids: [
    BidEntry(user: 'ScreenKing', amount: 230, time: DateTime.now().subtract(const Duration(hours: 2))),
    BidEntry(user: 'ProGamer99', amount: 275, time: DateTime.now().subtract(const Duration(hours: 1))),
    BidEntry(user: 'TechWatcher', amount: 310, time: DateTime.now().subtract(const Duration(minutes: 25))),
  ]),
];

// ─── Screen ──────────────────────────────────────────────────
class AuctionScreen extends ConsumerStatefulWidget {
  const AuctionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends ConsumerState<AuctionScreen> {
  late Timer _timer;
  final Map<String, Duration> _timers = {};

  @override
  void initState() {
    super.initState();
    for (final a in _seed) _timers[a.id] = a.timeLeft;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        for (final key in _timers.keys.toList()) {
          if (_timers[key]!.inSeconds > 0) _timers[key] = _timers[key]! - const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  String _fmt(Duration d) {
    if (d.inSeconds <= 0) return 'Ended';
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(auctionProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Row(children: [
          Text('Live Auctions', style: AppTextStyles.headline3),
          const SizedBox(width: AppDimensions.sm),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.badgeHotBg, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)), child: const Text('LIVE', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w800, fontFamily: 'Inter'))),
        ]),
      ),
      body: Column(children: [
        // Stats bar
        Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.md),
          child: Row(children: [
            _Stat('${items.length}', 'Live', AppColors.ctaPrimaryBg),
            _Div(),
            _Stat('${items.fold(0, (s, i) => s + i.totalBids)}', 'Total Bids', AppColors.success),
            _Div(),
            _Stat('\$${items.fold(0.0, (s, i) => s + i.currentBid).toStringAsFixed(0)}', 'Volume', AppColors.ratingFilled),
            _Div(),
            _Stat('${items.where((i) => (_timers[i.id]?.inMinutes ?? 0) < 60 && (_timers[i.id]?.inSeconds ?? 0) > 0).length}', 'Ending Soon', AppColors.error),
          ]),
        ),
        const SizedBox(height: 1),

        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(AppDimensions.lg),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.md),
          itemBuilder: (_, i) {
            final item = items[i];
            final tLeft = _timers[item.id] ?? item.timeLeft;
            final ended = tLeft.inSeconds <= 0;
            final soon = tLeft.inMinutes < 60 && !ended;

            return GestureDetector(
              onTap: () => _push(context, _AuctionDetailPage(item: item, timeLeft: tLeft, formatted: _fmt(tLeft))),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusLg), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
                  border: Border.all(color: soon ? AppColors.error.withOpacity(0.3) : Colors.transparent)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
                    child: SizedBox(height: 160, width: double.infinity, child: Stack(fit: StackFit.expand, children: [
                      CachedNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover, errorWidget: (_, __, ___) => ColoredBox(color: AppColors.backgroundPrimary, child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 64))))),
                      // Gradient overlay
                      Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]))),
                      // Badges
                      Positioned(top: 10, left: 10, child: Row(children: [
                        if (item.isHot) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.badgeHotBg, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)), child: Text('🔥 HOT', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800))),
                        if (soon) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(AppDimensions.radiusFull)), child: Text('⏰ ENDING SOON', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10)))],
                      ])),
                      // Timer overlay
                      Positioned(bottom: 10, right: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(AppDimensions.radiusSm)), child: Text(ended ? 'ENDED' : _fmt(tLeft), style: TextStyle(color: ended ? AppColors.textQuaternary : soon ? AppColors.ratingFilled : Colors.white, fontWeight: FontWeight.w800, fontSize: 14, fontFamily: 'Inter')))),
                    ])),
                  ),

                  Padding(padding: const EdgeInsets.all(AppDimensions.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(item.description, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppDimensions.sm),
                    Row(children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Current Bid', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                        Text('\$${item.currentBid.toStringAsFixed(2)}', style: AppTextStyles.priceMedium.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w800)),
                      ]),
                      const SizedBox(width: AppDimensions.lg),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Bids', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
                        Text('${item.totalBids}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800)),
                      ]),
                      const Spacer(),
                      if (!ended) ElevatedButton.icon(
                        onPressed: () => _showBidDialog(context, item),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
                        icon: const Icon(Icons.gavel_rounded, size: 16),
                        label: Text('Bid +\$5', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ])),
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }

  void _showBidDialog(BuildContext context, AuctionItem item) {
    final min = item.currentBid + 5;
    double bid = min;
    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (_, set) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      title: Text('Place Bid', style: AppTextStyles.headline3),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(item.name, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: AppDimensions.md),
        Text('\$${bid.toStringAsFixed(2)}', style: AppTextStyles.priceLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.ctaPrimaryBg)),
        Slider(value: bid, min: min, max: min + 100, divisions: 20, activeColor: AppColors.ctaPrimaryBg, onChanged: (v) => set(() => bid = v)),
        Text('Min: \$${min.toStringAsFixed(2)}', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
        ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref.read(auctionProvider.notifier).placeBid(item.id, bid, 'You');
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('✅ Bid \$${bid.toStringAsFixed(2)} placed!', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
              backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(AppDimensions.lg),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
            ));
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
          child: Text('Confirm Bid', style: AppTextStyles.buttonLabel),
        ),
      ],
    )));
  }

  void _push(BuildContext ctx, Widget w) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProviderScope(parent: ProviderScope.containerOf(ctx), child: w)));
}

// ─── Auction Detail Page ─────────────────────────────────────
class _AuctionDetailPage extends ConsumerWidget {
  final AuctionItem item;
  final Duration timeLeft;
  final String formatted;
  const _AuctionDetailPage({required this.item, required this.timeLeft, required this.formatted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveItem = ref.watch(auctionProvider).where((i) => i.id == item.id).firstOrNull ?? item;
    final ended = timeLeft.inSeconds <= 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(slivers: [
        SliverAppBar(expandedHeight: 300, pinned: true, backgroundColor: Colors.white,
          leading: GestureDetector(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]), child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textPrimary))),
          flexibleSpace: FlexibleSpaceBar(background: CachedNetworkImage(imageUrl: liveItem.imageUrl, fit: BoxFit.cover, errorWidget: (_, __, ___) => ColoredBox(color: AppColors.backgroundPrimary, child: Center(child: Text(liveItem.emoji, style: const TextStyle(fontSize: 80)))))),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(AppDimensions.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(liveItem.name, style: AppTextStyles.headline2.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppDimensions.xs),
          Text(liveItem.description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.6)),
          const SizedBox(height: AppDimensions.lg),

          // Live stats
          Row(children: [
            _BigStat('\$${liveItem.currentBid.toStringAsFixed(2)}', 'Current Bid', AppColors.ctaPrimaryBg),
            const SizedBox(width: AppDimensions.md),
            _BigStat('${liveItem.totalBids}', 'Bids', AppColors.success),
            const SizedBox(width: AppDimensions.md),
            _BigStat(ended ? 'Ended' : formatted, 'Time Left', ended ? AppColors.textQuaternary : timeLeft.inMinutes < 60 ? AppColors.error : AppColors.textPrimary),
          ]),

          const SizedBox(height: AppDimensions.lg),

          // Price Chart (visual bar chart from bid history)
          Text('Price History', style: AppTextStyles.headline3),
          const SizedBox(height: AppDimensions.sm),
          Container(padding: const EdgeInsets.all(AppDimensions.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
            child: liveItem.bids.isEmpty
              ? Center(child: Padding(padding: const EdgeInsets.all(AppDimensions.lg), child: Text('No bids yet', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textQuaternary))))
              : Column(children: [
                  SizedBox(height: 100, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const SizedBox(width: AppDimensions.xs),
                    ...[BidEntry(user: 'Start', amount: liveItem.startBid, time: DateTime.now()), ...liveItem.bids].map((bid) {
                      final maxBid = liveItem.currentBid;
                      final ratio = (bid.amount / maxBid).clamp(0.1, 1.0);
                      return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(height: 80 * ratio, decoration: BoxDecoration(color: bid.user == 'You' ? AppColors.success : AppColors.ctaPrimaryBg.withOpacity(0.6 + ratio * 0.4), borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
                      ])));
                    }),
                  ])),
                  const SizedBox(height: AppDimensions.xs),
                  Row(children: [
                    Expanded(child: Text('Start', style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary, fontSize: 9), textAlign: TextAlign.center)),
                    ...liveItem.bids.map((_) => Expanded(child: const Text('', style: TextStyle(fontSize: 9)))),
                  ]),
                ]),
          ),

          const SizedBox(height: AppDimensions.lg),

          // Bid History
          Text('Bid History', style: AppTextStyles.headline3),
          const SizedBox(height: AppDimensions.sm),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
            child: liveItem.bids.isEmpty
              ? const Padding(padding: EdgeInsets.all(AppDimensions.lg), child: Center(child: Text('No bids placed yet')))
              : Column(children: liveItem.bids.reversed.map((bid) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
                  child: Row(children: [
                    CircleAvatar(radius: 16, backgroundColor: bid.user == 'You' ? AppColors.success.withOpacity(0.15) : AppColors.statusActiveBg, child: Text(bid.user[0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: bid.user == 'You' ? AppColors.success : AppColors.ctaPrimaryBg))),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(bid.user == 'You' ? 'You 🏆' : bid.user, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                      Text(_fmtTime(bid.time), style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary)),
                    ])),
                    Text('\$${bid.amount.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: bid.user == 'You' ? AppColors.success : AppColors.ctaPrimaryBg)),
                  ]),
                )).toList()),
          ),

          const SizedBox(height: 100),
        ]))),
      ]),
      bottomNavigationBar: ended ? null : Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
        padding: EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, MediaQuery.of(context).padding.bottom + AppDimensions.sm),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('Current Bid', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
            Text('\$${liveItem.currentBid.toStringAsFixed(2)}', style: AppTextStyles.priceLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.ctaPrimaryBg)),
          ])),
          SizedBox(height: 52, child: ElevatedButton.icon(
            onPressed: () => _showBid(context, ref, liveItem),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)), padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl)),
            icon: const Icon(Icons.gavel_rounded, size: 20),
            label: Text('Place Bid', style: AppTextStyles.buttonLabel),
          )),
        ]),
      ),
    );
  }

  void _showBid(BuildContext context, WidgetRef ref, AuctionItem item) {
    final min = item.currentBid + 5; double bid = min;
    showDialog(context: context, builder: (_) => StatefulBuilder(builder: (_, set) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      title: Text('Place Bid', style: AppTextStyles.headline3),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('\$${bid.toStringAsFixed(2)}', style: AppTextStyles.priceLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.ctaPrimaryBg)),
        Slider(value: bid, min: min, max: min + 100, divisions: 20, activeColor: AppColors.ctaPrimaryBg, onChanged: (v) => set(() => bid = v)),
        Text('Min bid: \$${min.toStringAsFixed(2)}', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
        ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref.read(auctionProvider.notifier).placeBid(item.id, bid, 'You');
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
          child: Text('Confirm', style: AppTextStyles.buttonLabel),
        ),
      ],
    )));
  }

  String _fmtTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

// ─── Helpers ─────────────────────────────────────────────────
class _Stat extends StatelessWidget {
  final String value, label; final Color color;
  const _Stat(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: color)),
    Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary, fontSize: 10), textAlign: TextAlign.center),
  ]));
}

class _Div extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs));
}

class _BigStat extends StatelessWidget {
  final String value, label; final Color color;
  const _BigStat(this.value, this.label, this.color);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(padding: const EdgeInsets.all(AppDimensions.md), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(children: [
      Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: color), textAlign: TextAlign.center),
      const SizedBox(height: 2),
      Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary), textAlign: TextAlign.center),
    ]),
  ));
}
