// lib/presentation/screens/date/profile_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/dating_profile_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  final DatingProfileModel profile;
  final VoidCallback? onUnlock;
  final VoidCallback? onSuperLike;

  const ProfileDetailScreen({
    super.key,
    required this.profile,
    this.onUnlock,
    this.onSuperLike,
  });

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // معرض الصور
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemCount: profile.imageUrls.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    profile.imageUrls[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.grey,
                      child: const Icon(Icons.person, color: Colors.white54, size: 80),
                    ),
                  ),
                  if (profile.isLocked)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_rounded, color: AppColors.white, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              'This profile is locked',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Use a key to unlock and see full profile',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onUnlock?.call();
                              },
                              icon: const Icon(Icons.vpn_key_rounded),
                              label: const Text('Unlock with Key'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.dating,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          // شريط علوي
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
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  Row(
                    children: [
                      if (profile.isBoosted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text('BOOSTED', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${profile.imageUrls.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // مؤشر الصور
          if (profile.imageUrls.length > 1)
            Positioned(
              bottom: 250,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  profile.imageUrls.length,
                  (index) => Container(
                    width: 40,
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index ? Colors.white : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          // معلومات الملف الشخصي
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${profile.name}, ${profile.age}',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: AppColors.electricBlue, size: 22),
                      ],
                      const Spacer(),
                      if (!profile.isLocked)
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSuperLike?.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.neonYellow.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.neonYellow, width: 2),
                            ),
                            child: const Icon(Icons.star_rounded, color: AppColors.neonYellow, size: 28),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.grey2, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.city} · ${profile.distance}',
                        style: const TextStyle(color: AppColors.grey2, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.bio,
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.interests.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.dating.withOpacity(0.6)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(tag, style: const TextStyle(color: AppColors.dating, fontSize: 13)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  if (!profile.isLocked)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // إعجاب
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.dating,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('LIKE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.neonRed, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('NOPE', style: TextStyle(color: AppColors.neonRed, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
