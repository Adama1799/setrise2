// lib/presentation/screens/date/dating_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/dating_profile_model.dart';
import 'widgets/swipeable_card.dart';
import 'filter_sheet.dart';
import 'search_screen.dart';
import 'profile_detail_screen.dart';
import 'icebreaker_sheet.dart';

class DatingScreen extends StatefulWidget {
  const DatingScreen({super.key});

  @override
  State<DatingScreen> createState() => _DatingScreenState();
}

class _DatingScreenState extends State<DatingScreen> {
  late List<DatingProfileModel> _allProfiles;
  late List<DatingProfileModel> _filteredProfiles;
  int _currentIndex = 0;
  final Set<String> _matches = {};
  int _keys = 3; // ✅ عدد المفاتيح المتاحة

  // إعدادات الفلترة
  int _maxDistance = 100;
  int _ageFrom = 18;
  int _ageTo = 35;
  bool _sortBySharedInterests = false; // ✅ ترتيب حسب الاهتمامات المشتركة
  bool _incognitoMode = false; // ✅ وضع التصفح الخفي

  // اهتمامات المستخدم الحالي (محاكاة)
  final List<String> _myInterests = ['Travel', 'Music', 'Tech', 'Photography'];

  @override
  void initState() {
    super.initState();
    _allProfiles = DatingProfileModel.getMockProfiles();
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      _filteredProfiles = _allProfiles.where((profile) {
        final distance = int.tryParse(profile.distance.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        if (distance > _maxDistance) return false;
        if (profile.age < _ageFrom || profile.age > _ageTo) return false;
        return true;
      }).toList();

      if (_sortBySharedInterests) {
        _filteredProfiles.sort((a, b) {
          final aShared = a.interests.where((i) => _myInterests.contains(i)).length;
          final bShared = b.interests.where((i) => _myInterests.contains(i)).length;
          return bShared.compareTo(aShared);
        });
      }

      _currentIndex = 0;
    });
  }

  void _shuffleProfiles() {
    setState(() {
      _filteredProfiles.shuffle();
      _currentIndex = 0;
    });
  }

  void _handleSwipe(bool isLiked) {
    if (_currentIndex >= _filteredProfiles.length) return;

    final profile = _filteredProfiles[_currentIndex];
    if (isLiked) {
      if (_currentIndex % 2 == 0) {
        _matches.add(profile.id);
        _showMatchDialog(profile);
        return;
      }
    }

    setState(() => _currentIndex++);
  }

  void _handleSuperLike(DatingProfileModel profile) {
    setState(() => _currentIndex++);
    _showMatchDialog(profile, isSuperLike: true);
  }

  void _showMatchDialog(DatingProfileModel profile, {bool isSuperLike = false}) {
    HapticFeedback.mediumImpact();
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
              colors: [
                isSuperLike ? AppColors.neonYellow.withOpacity(0.9) : AppColors.neonRed.withOpacity(0.9),
                AppColors.dating.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isSuperLike ? '🌟' : '💛', style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text(
                isSuperLike ? 'Super Match!' : "It's a Match!",
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
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
                    _showIcebreakerSheet(profile);
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

  void _showIcebreakerSheet(DatingProfileModel profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => IcebreakerSheet(
        matchName: profile.name,
        onSend: () {
          Navigator.pop(context);
          setState(() => _currentIndex++);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Message sent to ${profile.name}! 💬'),
              backgroundColor: AppColors.dating,
            ),
          );
        },
      ),
    );
  }

  void _unlockProfile(DatingProfileModel profile) {
    if (_keys <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No keys available! Watch an ad to get more.'),
          backgroundColor: AppColors.neonRed,
        ),
      );
      return;
    }
    setState(() {
      _keys--;
      final index = _allProfiles.indexWhere((p) => p.id == profile.id);
      if (index != -1) {
        _allProfiles[index] = DatingProfileModel(
          id: profile.id,
          name: profile.name,
          age: profile.age,
          city: profile.city,
          distance: profile.distance,
          bio: profile.bio,
          imageUrls: profile.imageUrls,
          interests: profile.interests,
          isVerified: profile.isVerified,
          isLocked: false,
          isBoosted: profile.isBoosted,
        );
        _applyFilter();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile unlocked! $_keys keys remaining.'),
        backgroundColor: AppColors.neonGreen,
      ),
    );
  }

  void _openProfileDetail(DatingProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(
          profile: profile,
          onUnlock: () => _unlockProfile(profile),
          onSuperLike: () => _handleSuperLike(profile),
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => DateFilterSheet(
        maxDistance: _maxDistance,
        ageFrom: _ageFrom,
        ageTo: _ageTo,
        sortBySharedInterests: _sortBySharedInterests,
        incognitoMode: _incognitoMode,
        onApply: (distance, ageFrom, ageTo, sortByShared, incognito) {
          setState(() {
            _maxDistance = distance;
            _ageFrom = ageFrom;
            _ageTo = ageTo;
            _sortBySharedInterests = sortByShared;
            _incognitoMode = incognito;
          });
          _applyFilter();
        },
      ),
    );
  }

  void _resetProfiles() {
    setState(() {
      _allProfiles = DatingProfileModel.getMockProfiles();
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Date',
                    style: AppTextStyles.h4.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                  if (_incognitoMode) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_off_rounded, color: Colors.purple, size: 14),
                          const SizedBox(width: 4),
                          Text('INCOGNITO', style: AppTextStyles.labelSmall.copyWith(color: Colors.purple)),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.dating.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.vpn_key_rounded, color: AppColors.dating, size: 16),
                        const SizedBox(width: 4),
                        Text('$_keys', style: AppTextStyles.labelSmall.copyWith(color: AppColors.dating)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: AppColors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DateSearchScreen(
                            profiles: _allProfiles,
                            onMatchFound: (profile) {},
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shuffle_rounded, color: AppColors.white),
                    onPressed: _shuffleProfiles,
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: AppColors.white),
                    onPressed: _openFilterSheet,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _filteredProfiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_off_rounded, color: AppColors.grey2, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          'No profiles match your filters',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _openFilterSheet,
                          child: Text(
                            'Adjust Filters',
                            style: TextStyle(color: AppColors.dating, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                : _currentIndex < _filteredProfiles.length
                    ? Stack(
                        children: [
                          if (_currentIndex + 1 < _filteredProfiles.length)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SwipeableCard(
                                  profile: _filteredProfiles[_currentIndex + 1],
                                  isBackground: true,
                                  onTap: () => _openProfileDetail(_filteredProfiles[_currentIndex + 1]),
                                ),
                              ),
                            ),
                          Positioned.fill(
                            child: SwipeableCard(
                              profile: _filteredProfiles[_currentIndex],
                              onSwipeLeft: () => _handleSwipe(false),
                              onSwipeRight: () => _handleSwipe(true),
                              onTap: () => _openProfileDetail(_filteredProfiles[_currentIndex]),
                            ),
                          ),
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
                                  onTap: () => _handleSuperLike(_filteredProfiles[_currentIndex]),
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
          ),
        ],
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
