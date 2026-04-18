// lib/presentation/screens/dating/dating_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/dating_profile_model.dart';

class DatingScreen extends StatefulWidget {
  const DatingScreen({super.key});

  @override
  State<DatingScreen> createState() => _DatingScreenState();
}

class _DatingScreenState extends State<DatingScreen> {
  late List<DatingProfileModel> _allProfiles;
  late List<DatingProfileModel> _filteredProfiles;
  int _currentIndex = 0;
  final PageController _verticalPageController = PageController();

  double _distanceRange = 50.0;
  RangeValues _ageRange = const RangeValues(18, 80);
  bool _showOnlyVerified = false;

  @override
  void initState() {
    super.initState();
    _allProfiles = DatingProfileModel.getMockProfiles();
    _applyFilters();
  }

  @override
  void dispose() {
    _verticalPageController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredProfiles = _allProfiles.where((profile) {
        final distanceValue = double.tryParse(
          profile.distance.replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        if (distanceValue != null && distanceValue > _distanceRange) return false;
        if (profile.age < _ageRange.start || profile.age > _ageRange.end) return false;
        if (_showOnlyVerified && !profile.isVerified) return false;
        return true;
      }).toList();
      _currentIndex = 0;
      _verticalPageController.jumpToPage(0);
    });
  }

  void _nextProfile() {
    if (_currentIndex < _filteredProfiles.length - 1) {
      _verticalPageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else if (_filteredProfiles.isNotEmpty) {
      _applyFilters();
    }
  }

  void _showMatchDialog(DatingProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 40, backgroundImage: NetworkImage(profile.imageUrls[0])),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://picsum.photos/seed/current_user/100/100'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("It's a Match!", style: AppTextStyles.h4.copyWith(color: AppColors.white)),
              const SizedBox(height: 8),
              Text('You and ${profile.name} liked each other.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Keep Swiping', style: AppTextStyles.button.copyWith(color: AppColors.grey2)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Send Message'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Filters', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                const SizedBox(height: 24),
                Text('Distance', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white)),
                const SizedBox(height: 8),
                Slider(
                  value: _distanceRange,
                  min: 1,
                  max: 200,
                  divisions: 199,
                  label: '${_distanceRange.round()} km',
                  activeColor: AppColors.primary,
                  onChanged: (value) => setState(() => _distanceRange = value),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1 km', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                      Text('${_distanceRange.round()} km', style: AppTextStyles.bodyMedium),
                      Text('200 km', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Age Range', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white)),
                const SizedBox(height: 8),
                RangeSlider(
                  values: _ageRange,
                  min: 18,
                  max: 80,
                  divisions: 62,
                  labels: RangeLabels(
                    _ageRange.start.round().toString(),
                    _ageRange.end.round().toString(),
                  ),
                  activeColor: AppColors.primary,
                  onChanged: (values) => setState(() => _ageRange = values),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('18', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                      Text('${_ageRange.start.round()}-${_ageRange.end.round()}',
                          style: AppTextStyles.bodyMedium),
                      Text('80', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: _showOnlyVerified,
                      onChanged: (value) => setState(() => _showOnlyVerified = value ?? false),
                      activeColor: AppColors.primary,
                    ),
                    Text('Show only verified profiles',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _distanceRange = 50.0;
                            _ageRange = const RangeValues(18, 80);
                            _showOnlyVerified = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Reset', style: TextStyle(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Apply', style: AppTextStyles.button),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.grey,
                    backgroundImage: const NetworkImage('https://picsum.photos/seed/current_user/100/100'),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Date', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.tune_rounded, color: AppColors.white),
                    onPressed: _showFilterSheet,
                  ),
                ],
              ),
            ),
          ),
          _buildStoriesRow(),
          Expanded(
            child: _filteredProfiles.isEmpty
                ? Center(
                    child: Text('No profiles match your filters',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)))
                : PageView.builder(
                    controller: _verticalPageController,
                    scrollDirection: Axis.vertical,
                    itemCount: _filteredProfiles.length,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemBuilder: (context, index) {
                      final profile = _filteredProfiles[index];
                      return _ProfilePage(
                        profile: profile,
                        onLike: () {
                          if (Random().nextBool()) _showMatchDialog(profile);
                          _nextProfile();
                        },
                        onDislike: _nextProfile,
                        onSuperLike: _nextProfile,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesRow() {
    final stories = _allProfiles.where((p) => p.hasStory).toList();
    if (stories.isEmpty) return const SizedBox.shrink();
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final profile = stories[index];
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 29,
                    backgroundImage: NetworkImage(profile.imageUrls[0]),
                  ),
                ),
                const SizedBox(height: 4),
                Text(profile.name, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final DatingProfileModel profile;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;

  const _ProfilePage({
    required this.profile,
    required this.onLike,
    required this.onDislike,
    required this.onSuperLike,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _SwipeableCard(
            profile: profile,
            onLike: onLike,
            onDislike: onDislike,
            onSuperLike: onSuperLike,
          ),
        ),
        SliverToBoxAdapter(
          child: _ActionButtons(
            onDislike: onDislike,
            onSuperLike: onSuperLike,
            onLike: onLike,
          ),
        ),
        SliverToBoxAdapter(
          child: _ProfileDetailsSection(profile: profile),
        ),
      ],
    );
  }
}

class _SwipeableCard extends StatefulWidget {
  final DatingProfileModel profile;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;

  const _SwipeableCard({
    required this.profile,
    required this.onLike,
    required this.onDislike,
    required this.onSuperLike,
  });

  @override
  State<_SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<_SwipeableCard>
    with SingleTickerProviderStateMixin {
  late PageController _imageController;
  int _currentImage = 0;
  double _dragOffset = 0.0;
  bool _showLike = false;
  bool _showNope = false;
  bool _showSuperLike = false;

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _showLike = _dragOffset > 40;
      _showNope = _dragOffset < -40;
      _showSuperLike = _dragOffset > 100;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragOffset > 120) {
      widget.onLike();
    } else if (_dragOffset < -120) {
      widget.onDislike();
    } else {
      setState(() {
        _dragOffset = 0.0;
        _showLike = false;
        _showNope = false;
        _showSuperLike = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.width / 1.66;

    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Container(
          height: cardHeight,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _imageController,
                  onPageChanged: (index) => setState(() => _currentImage = index),
                  itemCount: widget.profile.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.profile.imageUrls[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.profile.imageUrls.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImage == index
                              ? AppColors.white
                              : AppColors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.profile.name}, ${widget.profile.age}',
                            style: AppTextStyles.h4.copyWith(color: Colors.white),
                          ),
                          if (widget.profile.isVerified) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.verified, color: AppColors.primary, size: 18),
                          ],
                          if (widget.profile.isBoosted) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('BOOSTED',
                                  style: AppTextStyles.caption.copyWith(color: Colors.white)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.profile.city} • ${widget.profile.distance}',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_showLike)
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Transform.rotate(
                      angle: -0.15,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('LIKE', style: AppTextStyles.h4.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                if (_showNope)
                  Positioned(
                    top: 30,
                    left: 30,
                    child: Transform.rotate(
                      angle: 0.15,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('NOPE', style: AppTextStyles.h4.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                if (_showSuperLike)
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.white),
                            const SizedBox(width: 8),
                            Text('SUPER LIKE',
                                style: AppTextStyles.h4.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;

  const _ActionButtons({
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CircularButton(icon: Icons.close_rounded, color: AppColors.error, onPressed: onDislike),
          _CircularButton(icon: Icons.star_rounded, color: AppColors.primary, onPressed: onSuperLike, size: 56, iconSize: 28),
          _CircularButton(icon: Icons.favorite_rounded, color: AppColors.primary, onPressed: onLike),
        ],
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  const _CircularButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 56,
    this.iconSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: iconSize),
        onPressed: onPressed,
      ),
    );
  }
}

class _ProfileDetailsSection extends StatefulWidget {
  final DatingProfileModel profile;

  const _ProfileDetailsSection({required this.profile});

  @override
  State<_ProfileDetailsSection> createState() => _ProfileDetailsSectionState();
}

class _ProfileDetailsSectionState extends State<_ProfileDetailsSection> {
  bool _isBioExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.profile.bio.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.white)),
                const SizedBox(height: 8),
                Text(
                  widget.profile.bio,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
                  maxLines: _isBioExpanded ? null : 2,
                  overflow: _isBioExpanded ? null : TextOverflow.ellipsis,
                ),
                if (widget.profile.bio.length > 100)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() => _isBioExpanded = !_isBioExpanded),
                      child: Text(
                        _isBioExpanded ? 'Less' : 'More',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          Text('Interests', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.white)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.profile.interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.grey3.withOpacity(0.3)),
                ),
                child: Text(interest, style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Photos', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.white)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.profile.imageUrls.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.profile.imageUrls[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
