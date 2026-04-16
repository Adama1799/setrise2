// lib/presentation/screens/date/dating_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/dating_profile_model.dart';
import 'widgets/swipeable_card.dart';

class DatingScreen extends StatefulWidget {
  const DatingScreen({super.key});

  @override
  State<DatingScreen> createState() => _DatingScreenState();
}

class _DatingScreenState extends State<DatingScreen> {
  late List<DatingProfileModel> _profiles;
  int _currentIndex = 0;
  final Set<String> _matches = {};

  @override
  void initState() {
    super.initState();
    _profiles = DatingProfileModel.getMockProfiles();
  }

  void _handleSwipe(bool isLiked) {
    if (_currentIndex >= _profiles.length) return;
    
    final profile = _profiles[_currentIndex];
    if (isLiked) {
      // محاكاة المطابقة (Match) - احتمالية 40%
      if (_currentIndex % 2 == 0) {
        _matches.add(profile.id);
        _showMatchDialog(profile);
        return;
      }
    }
    
    setState(() {
      _currentIndex++;
    });
  }

  void _showMatchDialog(DatingProfileModel profile) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.neonRed.withOpacity(0.9), AppColors.dating.withOpacity(0.9)],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💛', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              const Text(
                "It's a Match!",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You and ${profile.name} liked each other!',
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex++);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Send Message 💬', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentIndex++);
                },
                child: const Text('Keep Swiping', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetProfiles() {
    setState(() {
      _profiles = DatingProfileModel.getMockProfiles();
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: _currentIndex < _profiles.length
          ? Stack(
              children: [
                // بطاقة الخلفية (إن وجدت)
                if (_currentIndex + 1 < _profiles.length)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SwipeableCard(
                        profile: _profiles[_currentIndex + 1],
                        isBackground: true,
                      ),
                    ),
                  ),
                // البطاقة الأمامية
                Positioned.fill(
                  child: SwipeableCard(
                    profile: _profiles[_currentIndex],
                    onSwipeLeft: () => _handleSwipe(false),
                    onSwipeRight: () => _handleSwipe(true),
                  ),
                ),
                // أزرار التحكم السفلية
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.close_rounded,
                        color: AppColors.neonRed,
                        onTap: () => _handleSwipe(false),
                      ),
                      _ActionButton(
                        icon: Icons.star_rounded,
                        color: AppColors.neonYellow,
                        size: 50,
                        onTap: () => _handleSwipe(true),
                      ),
                      _ActionButton(
                        icon: Icons.favorite_rounded,
                        color: AppColors.dating,
                        onTap: () => _handleSwipe(true),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  const Text(
                    'No more profiles!',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Check back later', style: TextStyle(color: AppColors.grey2, fontSize: 14)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _resetProfiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dating,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Start Over', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    this.size = 28,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          color: AppColors.background,
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
