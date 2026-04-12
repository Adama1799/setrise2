Enter// lib/features/stories/presentation/widgets/story_card.dart

import 'package:flutter/material.dart';
import '../../domain/entities/story_entity.dart';

class StoryCard extends StatelessWidget {
  final StoryEntity story;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn = story.status == StoryStatus.own;
    final title = isOwn ? 'Your Story' : story.username;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 108,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ─── Card ──────────────────────────────────────────────────────
            AspectRatio(
              aspectRatio: 9 / 14,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  // ✅ Fix: استخدام story.borderColor بدل Colors.white الثابت
                  border: Border.all(
                    color: story.borderColor,
                    width: 2.5,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2B2B2B), Color(0xFF101010)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: story.borderColor.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.5),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background / Avatar
                      _buildBackground(),

                      // Gradient overlay bottom
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xCC000000)],
                            stops: [0.55, 1.0],
                          ),
                        ),
                      ),

                      // Username
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 9,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── LIVE Badge ────────────────────────────────────────────────
            if (story.isLive)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF2200),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

            // ─── Add Button (Your Story) ────────────────────────────────────
            if (isOwn)
              Positioned(
                bottom: 28,
                right: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFF39FF14), // neonGreen
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (story.avatar != null && story.avatar!.isNotEmpty) {
      return Image.network(
        story.avatar!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultBackground(),
      );
    }
    return _defaultBackground();
  }

  Widget _defaultBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B2B2B), Color(0xFF151515)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 40,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
