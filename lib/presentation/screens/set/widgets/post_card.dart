import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/post_model.dart';
import 'post_info_sheet.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final Function(PostModel) onUpdate;
  final VoidCallback onSwipeNext;

  const PostCard({
    super.key,
    required this.post,
    required this.onUpdate,
    required this.onSwipeNext,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Color get _accent {
    final hsl = HSLColor.fromColor(widget.post.backgroundColor);
    return hsl.withSaturation(1.0).withLightness(0.62).toColor();
  }

  void _toggleLike() {
    widget.onUpdate(
      widget.post.copyWith(
        isLiked: !widget.post.isLiked,
        likesCount: widget.post.isLiked
            ? widget.post.likesCount - 1
            : widget.post.likesCount + 1,
      ),
    );
  }

  void _toggleFollow() {
    widget.onUpdate(widget.post.copyWith(isFollowing: !widget.post.isFollowing));
  }

  void _togglePlay() {
    widget.onUpdate(widget.post.copyWith(isPlaying: !widget.post.isPlaying));
  }

  void _openComments(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentsSheet(accent: _accent),
    );
  }

  void _openInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PostInfoSheet(
        post: widget.post,
        accent: _accent,
        onFollow: _toggleFollow,
        onMessage: () => _openMessage(context),
      ),
    );
  }

  void _openMessage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MessageSheet(
        username: widget.post.username,
        accent: _accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: widget.post.backgroundColor),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.post.backgroundColor.withOpacity(0.70),
                    Colors.black.withOpacity(0.72),
                  ],
                ),
              ),
            ),
          ),

          if (!widget.post.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 82,
              ),
            ),

          Positioned(
            right: 12,
            bottom: bottomSafe + 18,
            child: Column(
              children: [
                _ActionIcon(
                  icon: widget.post.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: Formatters.formatCount(widget.post.likesCount),
                  color: widget.post.isLiked ? _accent : Colors.white,
                  onTap: _toggleLike,
                ),
                const SizedBox(height: 12),
                _ActionIcon(
                  icon: Icons.change_history_rounded,
                  label: 'Boost',
                  color: AppColors.neonGreen,
                  onTap: widget.onSwipeNext,
                ),
                const SizedBox(height: 12),
                _ActionIcon(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: Formatters.formatCount(widget.post.commentsCount),
                  color: Colors.white,
                  onTap: () => _openComments(context),
                ),
                const SizedBox(height: 14),
                _MusicDisk(accent: _accent),
                const SizedBox(height: 10),
                _ActionIcon(
                  icon: Icons.info_outline_rounded,
                  label: 'Info',
                  color: Colors.white,
                  onTap: () => _openInfo(context),
                ),
              ],
            ),
          ),

          Positioned(
            left: 14,
            right: 86,
            bottom: bottomSafe + 10,
            child: _BottomInfo(
              post: widget.post,
              accent: _accent,
              onFollow: _toggleFollow,
              onMessage: () => _openMessage(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicDisk extends StatefulWidget {
  final Color accent;

  const _MusicDisk({required this.accent});

  @override
  State<_MusicDisk> createState() => _MusicDiskState();
}

class _MusicDiskState extends State<_MusicDisk>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.65),
          border: Border.all(color: widget.accent, width: 2),
          boxShadow: [
            BoxShadow(color: widget.accent.withOpacity(0.35), blurRadius: 12),
          ],
        ),
        child: Icon(
          Icons.music_note_rounded,
          color: widget.accent,
          size: 18,
        ),
      ),
    );
  }
}

class _BottomInfo extends StatelessWidget {
  final PostModel post;
  final Color accent;
  final VoidCallback onFollow;
  final VoidCallback onMessage;

  const _BottomInfo({
    required this.post,
    required this.accent,
    required this.onFollow,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
                border: Border.all(color: accent, width: 2),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                post.username,
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onFollow,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: post.isFollowing ? Colors.white : accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: post.isFollowing ? Colors.white : accent.withOpacity(0.5),
                    width: 1.1,
                  ),
                ),
                child: Text(
                  post.isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: post.isFollowing ? Colors.black : accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onMessage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          post.title,
          style: AppTextStyles.postTitle.copyWith(
            color: Colors.white,
            height: 1.25,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          'شرح المحتوى هنا بشكل مرتب وواضح، ويمكن ربطه لاحقًا من البيانات الفعلية.',
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white70,
            height: 1.35,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        if (post.hashtags != null && post.hashtags!.trim().isNotEmpty)
          Text(
            post.hashtags!,
            style: AppTextStyles.labelSmall.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.music_note_rounded, size: 14, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              'Original Audio',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final Color accent;

  const _CommentsSheet({required this.accent});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.35,
      maxChildSize: 0.88,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Comments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              _CommentItem(user: 'sara', text: 'رائع جدًا 🔥'),
              _CommentItem(user: 'ahmed', text: 'التصميم ممتاز'),
              _CommentItem(user: 'nora', text: 'محتوى مرتب'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String user;
  final String text;

  const _CommentItem({
    required this.user,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageSheet extends StatefulWidget {
  final String username;
  final Color accent;

  const _MessageSheet({
    required this.username,
    required this.accent,
  });

  @override
  State<_MessageSheet> createState() => _MessageSheetState();
}

class _MessageSheetState extends State<_MessageSheet> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.32,
      maxChildSize: 0.70,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Message ${widget.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ctrl,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write your message...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: widget.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
