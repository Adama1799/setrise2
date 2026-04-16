import 'package:flutter/material.dart';
import '../../../data/models/dating_profile_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileDetailScreen extends StatelessWidget {
  final DatingProfileModel profile;
  final VoidCallback onUnlock;
  final VoidCallback onSuperLike;

  const ProfileDetailScreen({
    super.key,
    required this.profile,
    required this.onUnlock,
    required this.onSuperLike,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Image.network(
                    profile.imageUrls[0],
                    fit: BoxFit.cover,
                  ),
                  
                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withOpacity(0.8),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  
                  // Locked Overlay
                  if (profile.isLocked)
                    Container(
                      color: Colors.black.withOpacity(0.7),
                      child: BackdropFilter(
                        filter: const ColorFilter.matrix([
                          1, 0, 0, 0, 0,
                          0, 1, 0, 0, 0,
                          0, 0, 1, 0, 0,
                          0, 0, 0, 0.7, 0,
                        ]),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock_rounded,
                                color: Colors.white70,
                                size: 80,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'الملف الشخصي مقفل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'استخدم مفتاحاً لرؤية الصور والتفاصيل',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  // Boosted Badge
                  if (profile.isBoosted)
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.neonYellow, Colors.orange],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'مميز',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Age
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${profile.age}',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.grey1,
                        ),
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.neonBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.grey1,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        profile.city,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        profile.distance,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey1,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bio
                  if (!profile.isLocked) ...[
                    const Text(
                      'نبذة عني',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.bio,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Interests
                    const Text(
                      'الاهتمامات',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.interests
                          .map((interest) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  interest,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  if (profile.isLocked)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onUnlock,
                        icon: const Icon(Icons.vpn_key_rounded),
                        label: const Text('فتح الملف'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dating,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onSuperLike,
                            icon: const Icon(Icons.star_rounded),
                            label: const Text('Super Like'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.neonYellow,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
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
