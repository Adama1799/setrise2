// lib/presentation/screens/live/live_room_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../data/models/live_stream_model.dart';
import '../../widgets/live/live_chat_section.dart';
import '../../widgets/live/live_viewers_list.dart';
import '../../widgets/live/live_actions_bar.dart';

class LiveRoomScreen extends StatefulWidget {
  final LiveStreamModel stream;

  const LiveRoomScreen({
    super.key,
    required this.stream,
  });

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _showChat = true;
  bool _showViewers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Video Player
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            color: AppColors.black,
            child: Stack(
              children: [
                // Placeholder Video
                Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: AppColors.white.withOpacity(0.5),
                    size: 80,
                  ),
                ),
                // Live Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.live,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.fiber_manual_record,
                            color: AppColors.white, size: 8),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Viewers Count
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person,
                            color: AppColors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          Formatters.formatNumber(widget.stream.viewersCount),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Close Button
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Sheet
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,
            left: 0,
            right: 0,
            bottom: 0,
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.1,
              maxChildSize: 1,
              builder: (context, scrollController) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      // Drag Indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Host Info
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      CachedNetworkImageProvider(
                                          widget.stream.hostAvatar),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.stream.hostName,
                                        style: AppTypography.labelLarge,
                                      ),
                                      Text(
                                        widget.stream.hostUsername,
                                        style: AppTypography.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Inter'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.stream.title,
                              style: AppTypography.h3,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.stream.description,
                              style: AppTypography.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Divider(color: AppColors.border),
                      // Tabs
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showChat = true;
                                    _showViewers = false;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _showChat
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Chat',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.labelLarge,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showChat = false;
                                    _showViewers = true;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _showViewers
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Viewers',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.labelLarge,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content
                      SizedBox(
                        height: 300,
                        child: _showChat
                            ? LiveChatSection(stream: widget.stream)
                            : LiveViewersList(stream: widget.stream),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Actions Bar (Fixed at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LiveActionsBar(stream: widget.stream),
          ),
        ],
      ),
    );
  }
}
