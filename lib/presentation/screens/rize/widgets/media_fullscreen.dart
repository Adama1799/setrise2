// lib/presentation/screens/rize/widgets/media_fullscreen.dart
import 'package:flutter/material.dart';

class MediaFullScreen extends StatefulWidget {
  final List<String> mediaUrls;
  final int initialIndex;
  final String heroTag;

  const MediaFullScreen({
    super.key,
    required this.mediaUrls,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  State<MediaFullScreen> createState() => _MediaFullScreenState();
}

class _MediaFullScreenState extends State<MediaFullScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final TransformationController _transformController = TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    setState(() {
      if (_isZoomed) {
        _transformController.value = Matrix4.identity();
      } else {
        _transformController.value = Matrix4.identity()..scale(2.5);
      }
      _isZoomed = !_isZoomed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: widget.mediaUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: _toggleZoom,
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! > 500) Navigator.pop(context);
                },
                child: InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Hero(
                    tag: '${widget.heroTag}_$index',
                    child: Image.network(
                      widget.mediaUrls[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 64)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                  if (widget.mediaUrls.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.mediaUrls.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
