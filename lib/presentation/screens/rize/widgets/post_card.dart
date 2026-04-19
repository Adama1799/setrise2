import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/rize_model.dart';

class RizePostCard extends StatefulWidget {
  final RizePostModel post;
  final Function(RizePostModel) onUpdate;

  const RizePostCard({
    super.key,
    required this.post,
    required this.onUpdate,
  });

  @override
  State<RizePostCard> createState() => _RizePostCardState();
}

class _RizePostCardState extends State<RizePostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _likeCtrl;
  late final Animation<double> _likeScale;

  bool _showFullBody = false;
  int _currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();
    _likeCtrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _likeCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  void _toggleUpvote() {
    _likeCtrl.forward().then((_) => _likeCtrl.reverse());
    widget.onUpdate(
      widget.post.copyWith(
        isUpvoted: !widget.post.isUpvoted,
        upvotes: widget.post.isUpvoted
            ? widget.post.upvotes - 1
            : widget.post.upvotes + 1,
      ),
    );
  }

  void _toggleFollow() {
    widget.onUpdate(widget.post.copyWith(isFollowing: !widget.post.isFollowing));
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentsSheet(post: widget.post),
    );
  }

  void _showPostMenu(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Copy link'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.post.isFollowing ? 'Unfollow' : 'Follow'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: const Text('Report'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showRepostSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Share'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Repost'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Quote'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Share via...'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoViewScreen(imageUrl: imageUrl),
      ),
    );
  }

  void _openVideoViewer(BuildContext context, String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }

  void _openAudioPlayer(BuildContext context, String audioUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AudioPlayerScreen(audioUrl: audioUrl),
      ),
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    Animation<double>? animation,
  }) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    if (animation != null) {
      child = AnimatedBuilder(
        animation: animation,
        builder: (_, __) => Transform.scale(
          scale: animation.value,
          child: child,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }

  Widget _buildMedia() {
    final urls = widget.post.mediaUrls;
    if (urls.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            widget.post.mediaType == 'video'
                ? CupertinoIcons.videocam
                : widget.post.mediaType == 'audio'
                    ? CupertinoIcons.music_note_2
                    : CupertinoIcons.photo,
            color: Colors.white.withOpacity(0.35),
            size: 52,
          ),
        ),
      );
    }

    final aspect = 650 / 1000;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: aspect,
        child: Container(
          color: Colors.white.withOpacity(0.04),
          child: PageView.builder(
            itemCount: urls.length,
            onPageChanged: (index) => setState(() => _currentMediaIndex = index),
            itemBuilder: (context, index) {
              final url = urls[index];
              final mediaType = widget.post.mediaType;

              return GestureDetector(
                onTap: () {
                  if (mediaType == 'image') {
                    _openImageViewer(context, url);
                  } else if (mediaType == 'video') {
                    _openVideoViewer(context, url);
                  } else if (mediaType == 'audio') {
                    _openAudioPlayer(context, url);
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (mediaType == 'image')
                      Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.white.withOpacity(0.05),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              color: Colors.white.withOpacity(0.3),
                              size: 44,
                            ),
                          ),
                        ),
                      )
                    else if (mediaType == 'video')
                      Container(
                        color: Colors.black,
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.play_circle_fill,
                            color: Colors.white,
                            size: 72,
                          ),
                        ),
                      )
                    else if (mediaType == 'audio')
                      Container(
                        color: const Color(0xFF111111),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 92,
                                height: 92,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.08),
                                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                                ),
                                child: const Icon(
                                  CupertinoIcons.music_note_2,
                                  color: Colors.white,
                                  size: 42,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Tap to play',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.72),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (widget.post.mediaType == 'video')
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    if (urls.length > 1)
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentMediaIndex + 1}/${urls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF2C2C2E),
                child: Text(
                  post.userAvatar,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: _toggleFollow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: -0.1,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            post.username,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            Formatters.timeAgo(post.createdAt),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showPostMenu(context),
                child: Icon(
                  CupertinoIcons.ellipsis,
                  color: Colors.white.withOpacity(0.4),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.title.isNotEmpty) ...[
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  _showFullBody || post.body.length <= 220
                      ? post.body
                      : '${post.body.substring(0, 220)}...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                if (post.body.length > 220) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => setState(() => _showFullBody = !_showFullBody),
                    child: Text(
                      _showFullBody ? 'Show less' : 'More',
                      style: const TextStyle(
                        color: AppColors.electricBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                _buildMedia(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _likeScale,
                      builder: (_, child) => Transform.scale(
                        scale: _likeScale.value,
                        child: child,
                      ),
                      child: _buildAction(
                        icon: post.isUpvoted
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        label: Formatters.formatCount(post.upvotes),
                        color: post.isUpvoted ? Colors.redAccent : Colors.white54,
                        onTap: _toggleUpvote,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildAction(
                      icon: CupertinoIcons.chat_bubble,
                      label: Formatters.formatCount(post.comments),
                      color: Colors.white54,
                      onTap: () => _showCommentsSheet(context),
                    ),
                    const SizedBox(width: 16),
                    _buildAction(
                      icon: CupertinoIcons.arrow_2_squarepath,
                      label: Formatters.formatCount(post.shares),
                      color: Colors.white54,
                      onTap: () => _showRepostSheet(context),
                    ),
                    const Spacer(),
                    _buildAction(
                      icon: post.isBookmarked
                          ? CupertinoIcons.bookmark_fill
                          : CupertinoIcons.bookmark,
                      label: '',
                      color: post.isBookmarked
                          ? AppColors.electricBlue
                          : Colors.white54,
                      onTap: () {
                        widget.onUpdate(
                          post.copyWith(isBookmarked: !post.isBookmarked),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoViewScreen extends StatelessWidget {
  final String imageUrl;

  const PhotoViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: true,
          aspectRatio: _videoController.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.electricBlue,
            handleColor: AppColors.electricBlue,
            backgroundColor: Colors.grey[700]!,
            bufferedColor: Colors.grey[600]!,
          ),
        );
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CupertinoActivityIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerScreen({super.key, required this.audioUrl});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late final AudioPlayer _player;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.audioUrl);
      await _player.play();
      if (mounted) {
        setState(() => _ready = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Audio could not be loaded',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: !_ready
          ? const Center(child: CupertinoActivityIndicator())
          : StreamBuilder<Duration>(
              stream: _player.positionStream,
              initialData: Duration.zero,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: _player.durationStream,
                  builder: (context, durationSnap) {
                    final duration = durationSnap.data ?? Duration.zero;
                    final totalMs = duration.inMilliseconds;
                    final currentMs = position.inMilliseconds.clamp(0, totalMs);
                    final progress = totalMs == 0 ? 0.0 : currentMs / totalMs;

                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                              border: Border.all(color: Colors.white.withOpacity(0.12)),
                            ),
                            child: const Icon(
                              CupertinoIcons.music_note_2,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Audio playing',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Slider(
                            value: progress.clamp(0.0, 1.0),
                            onChanged: (value) {
                              final seekTo = Duration(
                                milliseconds: (totalMs * value).round(),
                              );
                              _player.seek(seekTo);
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(color: Colors.white54),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          StreamBuilder<PlayerState>(
                            stream: _player.playerStateStream,
                            builder: (context, snapshot) {
                              final playing = snapshot.data?.playing ?? false;
                              return GestureDetector(
                                onTap: () {
                                  if (playing) {
                                    _player.pause();
                                  } else {
                                    _player.play();
                                  }
                                },
                                child: Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.electricBlue,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.electricBlue.withOpacity(0.35),
                                        blurRadius: 16,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    playing
                                        ? CupertinoIcons.pause_fill
                                        : CupertinoIcons.play_fill,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _CommentsSheet extends StatefulWidget {
  final RizePostModel post;

  const _CommentsSheet({required this.post});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<_ThreadComment> _comments = [
    _ThreadComment(
      id: '1',
      userId: 'u1',
      username: '@ahmed_codes',
      name: 'Ahmed',
      text: 'This is exactly what I was looking for! Great breakdown 🔥',
      likes: 24,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      replies: [
        _ThreadComment(
          id: '1-1',
          userId: 'u2',
          username: '@flutter_dev',
          name: 'Flutter Dev',
          text: 'Totally agree! The new features are amazing',
          likes: 8,
          isLiked: true,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
          replies: [
            _ThreadComment(
              id: '1-1-1',
              userId: 'current_user',
              username: '@you',
              name: 'You',
              text: 'Thanks for the feedback guys! 🙏',
              likes: 3,
              isLiked: false,
              createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
            ),
          ],
        ),
      ],
    ),
    _ThreadComment(
      id: '2',
      userId: 'u3',
      username: '@flutter_dev',
      name: 'Flutter Dev',
      text: 'Thanks for sharing this insight. Very helpful for beginners.',
      likes: 12,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
  ];

  String? _replyingToId;
  String? _replyingToName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      final comment = _ThreadComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        username: '@you',
        name: 'You',
        text: text,
        likes: 0,
        isLiked: false,
        createdAt: DateTime.now(),
      );

      if (_replyingToId != null) {
        _addReply(_comments, _replyingToId!, comment);
      } else {
        _comments.insert(0, comment);
      }

      _controller.clear();
      _replyingToId = null;
      _replyingToName = null;
    });
  }

  bool _addReply(
    List<_ThreadComment> comments,
    String parentId,
    _ThreadComment reply,
  ) {
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].id == parentId) {
        comments[i] = comments[i].copyWith(
          replies: [...comments[i].replies, reply],
        );
        return true;
      }
      if (_addReply(comments[i].replies, parentId, reply)) return true;
    }
    return false;
  }

  void _like(String id) {
    setState(() {
      final comment = _find(_comments, id);
      if (comment != null) {
        comment.isLiked = !comment.isLiked;
        comment.likes += comment.isLiked ? 1 : -1;
      }
    });
  }

  _ThreadComment? _find(List<_ThreadComment> comments, String id) {
    for (final c in comments) {
      if (c.id == id) return c;
      final found = _find(c.replies, id);
      if (found != null) return found;
    }
    return null;
  }

  void _delete(String id) {
    setState(() {
      _remove(_comments, id);
    });
  }

  bool _remove(List<_ThreadComment> comments, String id) {
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].id == id) {
        comments.removeAt(i);
        return true;
      }
      if (_remove(comments[i].replies, id)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Thread',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_comments.length})',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 24, thickness: 0.5, color: Colors.white.withOpacity(0.1)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return _ThreadCommentTile(
                  comment: _comments[index],
                  onReply: (id, name) {
                    setState(() {
                      _replyingToId = id;
                      _replyingToName = name;
                    });
                    _focusNode.requestFocus();
                  },
                  onDelete: _delete,
                  onLike: _like,
                  depth: 0,
                );
              },
            ),
          ),
          if (_replyingToId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF121212),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyingToName',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _replyingToId = null;
                      _replyingToName = null;
                    }),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          _buildReplyBar(),
        ],
      ),
    );
  }

  Widget _buildReplyBar() {
    final canSend = _controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF2C2C2E),
              child: Icon(
                CupertinoIcons.person_fill,
                color: Colors.white54,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _replyingToId != null ? 'Write a reply...' : 'Post your reply...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: canSend ? _send : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: canSend ? const Color(0xFF007AFF) : const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Reply',
                  style: TextStyle(
                    color: canSend ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadComment {
  final String id;
  final String userId;
  final String username;
  final String name;
  final String text;
  int likes;
  bool isLiked;
  final DateTime createdAt;
  List<_ThreadComment> replies;

  _ThreadComment({
    required this.id,
    required this.userId,
    required this.username,
    required this.name,
    required this.text,
    required this.likes,
    required this.isLiked,
    required this.createdAt,
    this.replies = const [],
  });

  _ThreadComment copyWith({
    String? id,
    String? userId,
    String? username,
    String? name,
    String? text,
    int? likes,
    bool? isLiked,
    DateTime? createdAt,
    List<_ThreadComment>? replies,
  }) {
    return _ThreadComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
    );
  }
}

class _ThreadCommentTile extends StatelessWidget {
  final _ThreadComment comment;
  final Function(String id, String name) onReply;
  final Function(String id) onDelete;
  final Function(String id) onLike;
  final int depth;

  const _ThreadCommentTile({
    required this.comment,
    required this.onReply,
    required this.onDelete,
    required this.onLike,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn = comment.userId == 'current_user';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF2C2C2E),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.white54,
                    size: 12,
                  ),
                ),
                if (comment.replies.isNotEmpty)
                  Container(
                    width: 1.5,
                    height: 20,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.username,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${Formatters.timeAgo(comment.createdAt)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      if (isOwn)
                        GestureDetector(
                          onTap: () => onDelete(comment.id),
                          child: Icon(
                            CupertinoIcons.trash,
                            color: Colors.redAccent.withOpacity(0.7),
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => onLike(comment.id),
                        child: Row(
                          children: [
                            Icon(
                              comment.isLiked
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: comment.isLiked
                                  ? Colors.redAccent
                                  : Colors.white54,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.formatCount(comment.likes),
                              style: TextStyle(
                                color: comment.isLiked
                                    ? Colors.redAccent
                                    : Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => onReply(comment.id, comment.username),
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: comment.replies.map((reply) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: _ThreadCommentTile(
                    comment: reply,
                    onReply: onReply,
                    onDelete: onDelete,
                    onLike: onLike,
                    depth: depth + 1,
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
