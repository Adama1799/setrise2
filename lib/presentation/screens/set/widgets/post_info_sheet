import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/post_model.dart';

class PostInfoSheet extends StatelessWidget {
  final PostModel post;
  final Color accent;
  final VoidCallback onFollow;
  final VoidCallback onMessage;

  const PostInfoSheet({
    super.key,
    required this.post,
    required this.accent,
    required this.onFollow,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isFollowing = post.isFollowing;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.48,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: const Color(0xFF0D0D0D).withOpacity(0.92),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                            border: Border.all(color: accent, width: 2),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: AppTextStyles.h5.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Profile connected to this post',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onFollow,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isFollowing ? Colors.white : accent.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isFollowing ? Colors.white : accent.withOpacity(0.55),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              isFollowing ? 'Following' : 'Follow',
                              style: TextStyle(
                                color: isFollowing ? Colors.black : accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _SectionTitle(title: 'Bio'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Text(
                            'هذا هو البايو الكامل لصاحب المحتوى. يمكن لاحقًا ربطه من قاعدة البيانات أو الـ API ويكون مرتبط مباشرة بحساب صاحب المنشور.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              height: 1.55,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SectionTitle(title: 'Content'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(
                                label: 'Title',
                                value: post.title,
                                accent: accent,
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                label: 'Type',
                                value: post.isPlaying ? 'Video / Media' : 'Image / Post',
                                accent: accent,
                              ),
                              const SizedBox(height: 12),
                              _InfoRow(
                                label: 'Music',
                                value: 'Original Audio',
                                accent: accent,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SectionTitle(title: 'Description'),
                        const SizedBox(height: 8),
                        _DarkCard(
                          child: Text(
                            'شرح المحتوى يظهر هنا بشكل مرتب وواضح. يمكنك لاحقًا جعله يأتي من البيانات الحقيقية الخاصة بالمنشور.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              height: 1.55,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (post.hashtags != null && post.hashtags!.trim().isNotEmpty) ...[
                          _SectionTitle(title: 'Category / Hashtags'),
                          const SizedBox(height: 8),
                          _DarkCard(
                            child: Text(
                              post.hashtags!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        _SectionTitle(title: 'Actions'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: onMessage,
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: onFollow,
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _DarkCard extends StatelessWidget {
  final Widget child;

  const _DarkCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(Icons.circle, color: accent, size: 8),
      ],
    );
  }
}
