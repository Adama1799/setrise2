// lib/presentation/screens/live/live_feed_screen.dart
// BUG FIX: Missing import 'live_room_screen.dart' — caused compile error
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/live_provider.dart';
import '../../widgets/live/live_card.dart';
import 'live_room_screen.dart'; // ✅ ADDED missing import

class LiveFeedScreen extends ConsumerStatefulWidget {
  const LiveFeedScreen({super.key});

  @override
  ConsumerState<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends ConsumerState<LiveFeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(liveProvider.notifier).loadLiveStreams();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveState = ref.watch(liveProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
        title: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.live,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(children: [
              Icon(Icons.fiber_manual_record, color: AppColors.white, size: 8),
              SizedBox(width: 4),
              Text('LIVE', style: TextStyle(
                color: AppColors.white, fontWeight: FontWeight.w900,
                fontSize: 12, fontFamily: 'Inter',
              )),
            ]),
          ),
          const SizedBox(width: 8),
          Text('Live', style: AppTypography.h2),
        ]),
        actions: [
          // Go Live button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showGoLiveDialog(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.live,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(children: [
                  Icon(Icons.videocam, color: AppColors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Go Live', style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.w700,
                      fontSize: 13, fontFamily: 'Inter')),
                ]),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(liveProvider.notifier).loadLiveStreams();
        },
        child: liveState.isLoading && liveState.liveStreams.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : liveState.liveStreams.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam_off,
                            size: 80, color: AppColors.textTertiary),
                        const SizedBox(height: 16),
                        Text('No Live Streams', style: AppTypography.h3),
                        const SizedBox(height: 8),
                        Text('Check back later', style: AppTypography.caption),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.live),
                          onPressed: () => _showGoLiveDialog(),
                          child: const Text('Be the first to go live!',
                              style: TextStyle(color: AppColors.white)),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: liveState.liveStreams.length,
                    itemBuilder: (context, index) {
                      final stream = liveState.liveStreams[index];
                      return LiveCard(
                        stream: stream,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LiveRoomScreen(stream: stream),
                            ),
                          );
                        },
                        onLike: () {
                          ref.read(liveProvider.notifier).toggleLike(stream.id);
                        },
                      );
                    },
                  ),
      ),
    );
  }

  void _showGoLiveDialog() {
    final titleCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Start Live Stream', style: AppTypography.h3),
          const SizedBox(height: 20),
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(hintText: 'Stream title...'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.live,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  ref.read(liveProvider.notifier).startLiveStream(
                    titleCtrl.text, '');
                  Navigator.pop(context);
                }
              },
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.videocam, color: AppColors.white),
                SizedBox(width: 8),
                Text('Go Live Now', style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold,
                    fontSize: 16, fontFamily: 'Inter')),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
