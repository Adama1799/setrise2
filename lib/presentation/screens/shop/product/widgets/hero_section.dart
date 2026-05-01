// lib/presentation/screens/shop/product/widgets/hero_section.dart
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/theme/app_colors.dart';

class HeroSection extends StatefulWidget {
  final List<String> imageUrls;
  final String heroTag;
  final String? videoUrl;
  const HeroSection({super.key, required this.imageUrls, required this.heroTag, this.videoUrl});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late PageController _pageController;
  int _currentPage = 0;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) => setState(() => _isVideoInitialized = true));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController != null && _isVideoInitialized) {
      return Hero(
        tag: widget.heroTag,
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: Stack(alignment: Alignment.center, children: [
            VideoPlayer(_videoController!),
            GestureDetector(
              onTap: () => setState(() => _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play()),
              child: Icon(_videoController!.value.isPlaying ? CupertinoIcons.pause_circle : CupertinoIcons.play_circle, color: CupertinoColors.white, size: 50),
            ),
          ]),
        ),
      );
    }

    return Hero(
      tag: widget.heroTag,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: widget.imageUrls.length,
            itemBuilder: (_, i) => Image.network(widget.imageUrls[i], fit: BoxFit.contain),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(bottom: 16, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(widget.imageUrls.length, (i) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == i ? AppColors.accent : AppColors.border)))),
            ),
        ]),
      ),
    );
  }
}
