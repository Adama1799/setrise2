// lib/presentation/screens/comments/comments_screen.dart
//
// ✅ شاشة تعليقات عامة — تعمل مع أي شاشة في التطبيق
// الاستخدام: منتج، لايف، بوست، ريلز، أي شيء مستقبلاً
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────
// نوع السياق — من أين يُستدعى
// ─────────────────────────────────────────────────────────────
enum CommentContextType {
  product,  // منتج متجر
  live,     // بث مباشر
  post,     // منشور
  reel,     // فيديو قصير
  general,  // عام
}

// ─────────────────────────────────────────────────────────────
// Model التعليق
// ─────────────────────────────────────────────────────────────
class CommentModel {
  final String id;
  final String userName;
  final String? avatarUrl;
  final String? text;
  final bool hasAudio;
  final List<String> imagePaths;
  final DateTime date;
  int likes;
  bool liked;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.userName,
    this.avatarUrl,
    this.text,
    this.hasAudio = false,
    this.imagePaths = const [],
    DateTime? date,
    this.likes = 0,
    this.liked = false,
    this.replies = const [],
  }) : date = date ?? DateTime.now();
}

// ─────────────────────────────────────────────────────────────
// CommentsScreen — الشاشة الرئيسية
// ─────────────────────────────────────────────────────────────
class CommentsScreen extends StatefulWidget {
  final String contextId;       // ID المنتج أو اللايف أو البوست
  final String contextName;     // اسم يظهر في الـ AppBar
  final CommentContextType contextType;
  final Color accent;

  const CommentsScreen({
    Key? key,
    required this.contextId,
    required this.contextName,
    required this.accent,
    this.contextType = CommentContextType.general,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isRecording = false;
  String? _replyingToName;
  String? _replyingToId;
  final List<String> _selectedImages = [];
  late List<CommentModel> _comments;

  @override
  void initState() {
    super.initState();
    // بيانات وهمية — استبدلها بـ API لاحقاً
    _comments = _mockComments();
  }

  List<CommentModel> _mockComments() => [
        CommentModel(
          id: '1',
          userName: 'Ahmed K.',
          text: 'رائع جداً! الجودة ممتازة 🔥',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          likes: 12,
          replies: [
            CommentModel(
              id: '1a',
              userName: 'Sara M.',
              text: 'أوافقك الرأي 👍',
              date: DateTime.now().subtract(const Duration(hours: 1)),
              likes: 3,
            ),
          ],
        ),
        CommentModel(
          id: '2',
          userName: 'Lina R.',
          text: 'هل يأتي بألوان أخرى؟',
          date: DateTime.now().subtract(const Duration(hours: 5)),
          likes: 5,
          hasAudio: true,
        ),
        CommentModel(
          id: '3',
          userName: 'Omar T.',
          text: 'سعر ممتاز مقارنة بالجودة 💯',
          date: DateTime.now().subtract(const Duration(days: 1)),
          likes: 20,
        ),
      ];

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── إرسال تعليق ─────────────────────────────────────────
  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty && _selectedImages.isEmpty && !_isRecording) return;

    HapticFeedback.mediumImpact();

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'You',
      text: text.isNotEmpty ? text : null,
      hasAudio: _isRecording,
      imagePaths: List.from(_selectedImages),
      date: DateTime.now(),
    );

    // لو في رد — نضيفه داخل التعليق الأصلي
    if (_replyingToId != null) {
      final idx = _comments.indexWhere((c) => c.id == _replyingToId);
      if (idx != -1) {
        setState(() {
          _comments[idx].replies.add(newComment);
        });
      }
    } else {
      setState(() {
        _comments.insert(0, newComment);
      });
    }

    setState(() {
      _textCtrl.clear();
      _selectedImages.clear();
      _isRecording = false;
      _replyingToId = null;
      _replyingToName = null;
    });
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }

  // ── عنوان حسب النوع ─────────────────────────────────────
  String get _title {
    switch (widget.contextType) {
      case CommentContextType.product: return 'Product Comments';
      case CommentContextType.live:    return 'Live Comments';
      case CommentContextType.post:    return 'Post Comments';
      case CommentContextType.reel:    return 'Reel Comments';
      case CommentContextType.general: return 'Comments';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 18, color: Color(0xFF1C1C1E)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C1C1E),
                    fontFamily: 'Inter')),
            Text(widget.contextName,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8E8E93),
                    fontFamily: 'Inter'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF2F2F7)),
        ),
      ),
      body: Column(
        children: [
          // ── قائمة التعليقات ──────────────────────────────
          Expanded(
            child: _comments.isEmpty
                ? _EmptyState(accent: widget.accent)
                : ListView.separated(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: _comments.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (_, i) => _CommentTile(
                      comment: _comments[i],
                      accent: widget.accent,
                      timeAgo: _timeAgo(_comments[i].date),
                      onLike: () => setState(() {
                        _comments[i].liked = !_comments[i].liked;
                      }),
                      onReply: () => setState(() {
                        _replyingToId = _comments[i].id;
                        _replyingToName = _comments[i].userName;
                      }),
                    ),
                  ),
          ),

          // ── شريط الإدخال ─────────────────────────────────
          _InputBar(
            ctrl: _textCtrl,
            accent: widget.accent,
            isRecording: _isRecording,
            replyingToName: _replyingToName,
            selectedImages: _selectedImages,
            onSend: _send,
            onRecord: () {
              HapticFeedback.heavyImpact();
              setState(() => _isRecording = !_isRecording);
            },
            onCancelReply: () => setState(() {
              _replyingToId = null;
              _replyingToName = null;
            }),
            onAddImage: () => setState(() => _selectedImages.add('img')),
            onRemoveImage: (i) =>
                setState(() => _selectedImages.removeAt(i)),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Color accent;
  const _EmptyState({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 52, color: accent.withOpacity(0.3)),
          const SizedBox(height: 12),
          const Text('No comments yet',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E8E93),
                  fontFamily: 'Inter')),
          const Text('Be the first to comment!',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFAEAEB2),
                  fontFamily: 'Inter')),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Comment Tile
// ─────────────────────────────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  final Color accent;
  final String timeAgo;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const _CommentTile({
    required this.comment,
    required this.accent,
    required this.timeAgo,
    required this.onLike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: accent.withOpacity(0.15),
              child: Text(
                comment.userName.isNotEmpty
                    ? comment.userName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    fontFamily: 'Inter'),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + time
                  Row(
                    children: [
                      Text(comment.userName,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C1C1E),
                              fontFamily: 'Inter')),
                      const SizedBox(width: 6),
                      Text(timeAgo,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8E8E93),
                              fontFamily: 'Inter')),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Text
                  if (comment.text != null)
                    Text(comment.text!,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3A3A3C),
                            height: 1.5,
                            fontFamily: 'Inter')),

                  // Audio
                  if (comment.hasAudio)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded,
                              size: 18, color: accent),
                          const SizedBox(width: 4),
                          Text('Voice message',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: accent,
                                  fontFamily: 'Inter')),
                          const SizedBox(width: 8),
                          const Text('0:12',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8E8E93),
                                  fontFamily: 'Inter')),
                        ],
                      ),
                    ),

                  // Images
                  if (comment.imagePaths.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: comment.imagePaths
                            .take(3)
                            .map((img) => Container(
                                  width: 72,
                                  height: 72,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F7),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.image_outlined,
                                      color: Color(0xFFAEAEB2)),
                                ))
                            .toList(),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Actions: Like + Reply
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onLike,
                        child: Row(
                          children: [
                            Icon(
                              comment.liked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 15,
                              color: comment.liked
                                  ? Colors.red
                                  : const Color(0xFF8E8E93),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${comment.likes + (comment.liked ? 1 : 0)}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8E8E93),
                                  fontFamily: 'Inter'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onReply,
                        child: const Text('Reply',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8E8E93),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Replies
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 46, top: 10),
            child: Column(
              children: comment.replies
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CommentTile(
                          comment: r,
                          accent: accent,
                          timeAgo: _ago(r.date),
                          onLike: () {},
                          onReply: () {},
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  String _ago(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}

// ─────────────────────────────────────────────────────────────
// Input Bar
// ─────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final Color accent;
  final bool isRecording;
  final String? replyingToName;
  final List<String> selectedImages;
  final VoidCallback onSend;
  final VoidCallback onRecord;
  final VoidCallback onCancelReply;
  final VoidCallback onAddImage;
  final ValueChanged<int> onRemoveImage;

  const _InputBar({
    required this.ctrl,
    required this.accent,
    required this.isRecording,
    required this.replyingToName,
    required this.selectedImages,
    required this.onSend,
    required this.onRecord,
    required this.onCancelReply,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF2F2F7))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Replying to banner
          if (replyingToName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: accent.withOpacity(0.07),
              child: Row(
                children: [
                  Icon(Icons.reply_rounded, size: 14, color: accent),
                  const SizedBox(width: 6),
                  Text('Replying to $replyingToName',
                      style: TextStyle(
                          fontSize: 12,
                          color: accent,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter')),
                  const Spacer(),
                  GestureDetector(
                    onTap: onCancelReply,
                    child: const Icon(Icons.close,
                        size: 14, color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
            ),

          // Selected images
          if (selectedImages.isNotEmpty)
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: selectedImages.length,
                itemBuilder: (_, i) => Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_outlined,
                          color: Color(0xFFAEAEB2)),
                    ),
                    Positioned(
                      top: 0, right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(i),
                        child: Container(
                          width: 16, height: 16,
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.close,
                              size: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Recording indicator
          if (isRecording)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: Colors.red.withOpacity(0.05),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  const Text('Recording...',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter')),
                  const Spacer(),
                  const Text('Tap mic to stop',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8E8E93),
                          fontFamily: 'Inter')),
                ],
              ),
            ),

          // Input row
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // صورة
                _Btn(
                    icon: Icons.image_outlined,
                    color: const Color(0xFF8E8E93),
                    onTap: onAddImage),
                const SizedBox(width: 4),

                // ميكروفون
                _Btn(
                    icon: isRecording
                        ? Icons.stop_circle_outlined
                        : Icons.mic_none_rounded,
                    color: isRecording ? Colors.red : const Color(0xFF8E8E93),
                    onTap: onRecord),
                const SizedBox(width: 8),

                // حقل النص
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: ctrl,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1C1C1E),
                          fontFamily: 'Inter'),
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: isRecording
                            ? 'Recording voice...'
                            : 'Add a comment...',
                        hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8E8E93),
                            fontFamily: 'Inter'),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // إرسال
                GestureDetector(
                  onTap: onSend,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: accent, shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded,
                        size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: const BoxDecoration(
            color: Color(0xFFF2F2F7), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
