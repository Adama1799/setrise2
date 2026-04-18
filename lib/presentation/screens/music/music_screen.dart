// lib/presentation/screens/music/music_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isPlaying = false;
  double _playbackProgress = 0.34;
  late AnimationController _miniPlayerController;

  @override
  void initState() {
    super.initState();
    _miniPlayerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _miniPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                backgroundColor: AppColors.surface,
                title: Text('Music', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                centerTitle: false,
                actions: [
                  IconButton(icon: Icon(Icons.search_rounded, color: AppColors.white), onPressed: () {}),
                  IconButton(icon: Icon(Icons.notifications_none_rounded, color: AppColors.white), onPressed: () {}),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 80),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF5AC8FA)]),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.play_arrow_rounded, color: AppColors.white, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Good evening', style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
                              const SizedBox(height: 4),
                              Text('Your Daily Mix', style: AppTextStyles.h5.copyWith(color: AppColors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Recently Played'),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 120,
                                      color: AppColors.surface,
                                      child: Stack(
                                        children: [
                                          Container(color: AppColors.primary.withOpacity(0.1 + (index * 0.05))),
                                          Center(child: Icon(Icons.album_rounded, color: AppColors.white.withOpacity(0.5), size: 48)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Track ${index + 1}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.white), maxLines: 1),
                                  Text('Artist ${index + 1}', style: AppTextStyles.caption.copyWith(color: AppColors.grey2), maxLines: 1),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Trending Now'),
                      const SizedBox(height: 16),
                      ...List.generate(5, (index) => _buildTrackRow(index)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildMiniPlayer(),
          if (_isPlaying) _buildNowPlayingBar(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h5.copyWith(color: AppColors.white)),
        Text('See All', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildTrackRow(int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          color: AppColors.surface,
          child: Icon(Icons.music_note_rounded, color: AppColors.primary.withOpacity(0.5)),
        ),
      ),
      title: Text('Track Title ${index + 1}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
      subtitle: Text('Artist Name', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
      trailing: IconButton(icon: Icon(Icons.more_vert_rounded, color: AppColors.grey2), onPressed: () {}),
      onTap: () => setState(() => _isPlaying = true),
    );
  }

  Widget _buildMiniPlayer() {
    return AnimatedBuilder(
      animation: _miniPlayerController,
      builder: (context, child) {
        return Positioned(
          bottom: _isPlaying ? 100 : 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => _isPlaying = true),
            child: Container(
              height: 70,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(width: 50, height: 50, color: AppColors.primary, child: Icon(Icons.album_rounded, color: Colors.white, size: 24))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Now Playing', style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                        const SizedBox(height: 4),
                        Text('Track Title', style: AppTextStyles.caption.copyWith(color: AppColors.grey2)),
                      ],
                    ),
                  ),
                  IconButton(icon: Icon(Icons.play_arrow_rounded, color: AppColors.white), onPressed: () => setState(() => _isPlaying = true)),
                  IconButton(icon: Icon(Icons.skip_next_rounded, color: AppColors.grey2), onPressed: () {}),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNowPlayingBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Container(width: 60, height: 60, color: AppColors.primary, child: Icon(Icons.album_rounded, color: Colors.white, size: 32))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Track Title', style: AppTextStyles.labelLarge.copyWith(color: AppColors.white)),
                  const SizedBox(height: 4),
                  Text('Artist Name', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.skip_previous_rounded, color: AppColors.white, size: 28), onPressed: () {}),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: AppColors.primary, size: 48),
              onPressed: () => setState(() => _isPlaying = !_isPlaying),
            ),
            IconButton(icon: Icon(Icons.skip_next_rounded, color: AppColors.white, size: 28), onPressed: () {}),
            const SizedBox(width: 12),
            IconButton(icon: Icon(Icons.close_rounded, color: AppColors.grey2), onPressed: () => setState(() => _isPlaying = false)),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
