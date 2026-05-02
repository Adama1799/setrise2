// lib/presentation/screens/shop/auction/auction_detail_screen.dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import 'auction_item.dart';

class AuctionDetailScreen extends StatefulWidget {
  final AuctionItem auction;
  const AuctionDetailScreen({super.key, required this.auction});
  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  final _bidCtrl = TextEditingController();
  late Timer _timer;
  late Duration _remaining;
  double _currentBid = 0;

  @override
  void initState() {
    super.initState();
    _currentBid = widget.auction.currentBid;
    _remaining = widget.auction.endTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _remaining = widget.auction.endTime.difference(DateTime.now())));
  }

  @override
  void dispose() {
    _timer.cancel();
    _bidCtrl.dispose();
    super.dispose();
  }

  String _fmt(Duration d) => d.isNegative ? 'Ended' : '${d.inHours.toString().padLeft(2,'0')}:${(d.inMinutes%60).toString().padLeft(2,'0')}:${(d.inSeconds%60).toString().padLeft(2,'0')}';

  @override
  Widget build(BuildContext context) {
    final ended = _remaining.isNegative;
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        middle: Text(widget.auction.name, style: const TextStyle(color: AppColors.white, fontSize: 17)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(widget.auction.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover)),
            const SizedBox(height: 16),
            Text(widget.auction.description, style: const TextStyle(color: AppColors.grey2)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                Row(children: [const Icon(CupertinoIcons.timer, color: AppColors.warning), const SizedBox(width: 8), Text('Time: ${_fmt(_remaining)}', style: TextStyle(color: ended ? AppColors.neonRed : AppColors.warning, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 8),
                Text('Current Bid: \$${_currentBid.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.shop, fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
            ),
            if (!ended) ...[
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: CupertinoTextField(controller: _bidCtrl, keyboardType: TextInputType.number, placeholder: 'Your bid', style: const TextStyle(color: AppColors.white), decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10)))),
                const SizedBox(width: 12),
                CupertinoButton(color: AppColors.shop, child: const Text('Place Bid'), onPressed: () {
                  final bid = double.tryParse(_bidCtrl.text);
                  if (bid != null && bid > _currentBid) { setState(() => _currentBid = bid); _bidCtrl.clear(); }
                }),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}
