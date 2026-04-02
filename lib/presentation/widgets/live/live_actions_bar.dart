// lib/presentation/widgets/live/live_actions_bar.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/live_stream_model.dart';

class LiveActionsBar extends StatefulWidget {
  final LiveStreamModel stream;

  const LiveActionsBar({
    super.key,
    required this.stream,
  });

  @override
  State<LiveActionsBar> createState() => _LiveActionsBarState();
}

class _LiveActionsBarState extends State<LiveActionsBar> {
  late LiveStreamModel _stream;

  @override
  void initState() {
    super.initState();
    _stream = widget.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewPadding.bottom + 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gift Button
          _buildActionButton(
            icon: Icons.card_giftcard,
            label: 'Gift',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => const GiftsSheet(),
              );
            },
          ),
          // Like Button
          _buildActionButton(
            icon: _stream.isLiked ? Icons.favorite : Icons.favorite_border,
            label: Formatters.formatNumber(_stream.likes),
            color: _stream.isLiked ? AppColors.primary : AppColors.textTertiary,
            onPressed: () {
              setState(() {
                _stream = _stream.copyWith(
                  isLiked: !_stream.isLiked,
                  likes: _stream.isLiked ? _stream.likes - 1 : _stream.likes + 1,
                );
              });
            },
          ),
          // Share Button
          _buildActionButton(
            icon: Icons.share,
            label: 'Share',
            onPressed: () {},
          ),
          // More Button
          _buildActionButton(
            icon: Icons.more_vert,
            label: '',
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width,
                  0,
                  0,
                  MediaQuery.of(context).size.height,
                ),
                items: [
                  const PopupMenuItem(
                    child: Text('Report'),
                  ),
                  const PopupMenuItem(
                    child: Text('Block'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color ?? AppColors.textTertiary,
            size: 24,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: color ?? AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class GiftsSheet extends StatelessWidget {
  const GiftsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final gifts = List.generate(
      12,
      (i) => {
        'id': '$i',
        'emoji': ['🎁', '💎', '🌹', '🎆', '⭐', '🔥', '💰', '🎵', '🏆', '👑', '💝', '🎈'][i],
        'name': ['Gift', 'Diamond', 'Rose', 'Fireworks', 'Star', 'Fire', 'Money', 'Music', 'Trophy', 'Crown', 'Heart', 'Balloon'][i],
        'price': ((i + 1) * 10),
      },
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Send a Gift', style: AppTypography.h3),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.border),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sent ${gift['emoji']} (${gift['price']} coins)'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(gift['emoji'], style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        gift['name'],
                        style: AppTypography.caption,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${gift['price']}',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
