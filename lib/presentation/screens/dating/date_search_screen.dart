import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/dating_profile_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DateSearchScreen extends StatefulWidget {
  final List<DatingProfileModel> profiles;
  final Function(DatingProfileModel) onMatchFound;

  const DateSearchScreen({
    super.key,
    required this.profiles,
    required this.onMatchFound,
  });

  @override
  State<DateSearchScreen> createState() => _DateSearchScreenState();
}

class _DateSearchScreenState extends State<DateSearchScreen>
    with TickerProviderStateMixin {
  // --- Search ---
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<DatingProfileModel> _filteredProfiles = [];
  String _currentQuery = '';

  // --- Search mode ---
  int _selectedCategory = 0;
  final List<String> _categories = ['الكل', 'الاسم', 'المدينة', 'الاهتمامات'];

  // --- Recent searches ---
  final List<String> _recentSearches = [
    'Travel',
    'Paris',
    'Music',
    'Photography',
  ];

  // --- Trending tags ---
  final List<Map<String, dynamic>> _trendingTags = [
    {'label': 'سفر', 'emoji': '✈️', 'count': '2.4k'},
    {'label': 'موسيقى', 'emoji': '🎵', 'count': '1.8k'},
    {'label': 'تصوير', 'emoji': '📸', 'count': '1.2k'},
    {'label': 'طبخ', 'emoji': '🍳', 'count': '980'},
    {'label': 'رياضة', 'emoji': '💪', 'count': '870'},
    {'label': 'قراءة', 'emoji': '📚', 'count': '650'},
    {'label': 'تقنية', 'emoji': '💻', 'count': '1.1k'},
    {'label': 'فن', 'emoji': '🎨', 'count': '540'},
  ];

  // --- Suggested profiles (random pick from all) ---
  late List<DatingProfileModel> _suggestedProfiles;

  // --- Animation ---
  late AnimationController _entryController;
  late AnimationController _resultsController;
  late Animation<double> _fadeAnimation;

  // --- Debounce ---
  DateTime? _lastSearchTime;

  @override
  void initState() {
    super.initState();

    // Pick 3 random suggested profiles
    final shuffled = List<DatingProfileModel>.from(widget.profiles)..shuffle();
    _suggestedProfiles = shuffled.take(3).toList();

    // Entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _resultsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _entryController.forward();

    // Auto-focus after animation
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _entryController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  SEARCH LOGIC
  // =========================================================================

  void _onSearchChanged(String query) {
    _currentQuery = query;

    // Debounce: wait 200ms before performing search
    final now = DateTime.now();
    if (_lastSearchTime != null &&
        now.difference(_lastSearchTime!).inMilliseconds < 200) {
      return;
    }
    _lastSearchTime = now;

    if (query.isEmpty) {
      setState(() => _filteredProfiles = []);
      return;
    }

    final lowerQuery = query.toLowerCase();

    setState(() {
      _filteredProfiles = widget.profiles.where((profile) {
        switch (_selectedCategory) {
          case 1: // Name only
            return profile.name.toLowerCase().contains(lowerQuery);
          case 2: // City only
            return profile.city.toLowerCase().contains(lowerQuery);
          case 3: // Interests only
            return profile.interests.any(
              (i) => i.toLowerCase().contains(lowerQuery),
            );
          default: // All
            final nameMatch =
                profile.name.toLowerCase().contains(lowerQuery);
            final cityMatch =
                profile.city.toLowerCase().contains(lowerQuery);
            final interestMatch = profile.interests.any(
              (i) => i.toLowerCase().contains(lowerQuery),
            );
            return nameMatch || cityMatch || interestMatch;
        }
      }).toList();
    });

    // Trigger results animation
    _resultsController.forward(from: 0);
  }

  void _onCategoryTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedCategory = index);
    if (_currentQuery.isNotEmpty) {
      _onSearchChanged(_currentQuery);
    }
  }

  void _onRecentSearchTap(String query) {
    HapticFeedback.selectionClick();
    _searchController.text = query;
    _focusNode.unfocus();
    _onSearchChanged(query);
  }

  void _onTrendingTagTap(String tag) {
    HapticFeedback.selectionClick();
    _searchController.text = tag;
    _focusNode.unfocus();
    _onSearchChanged(tag);
  }

  void _clearSearch() {
    HapticFeedback.lightImpact();
    _searchController.clear();
    _focusNode.requestFocus();
    setState(() {
      _currentQuery = '';
      _filteredProfiles = [];
    });
  }

  void _onProfileTap(DatingProfileModel profile) {
    HapticFeedback.mediumImpact();
    widget.onMatchFound(profile);
    Navigator.pop(context);
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryChips(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'البحث',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SEARCH BAR
  // ---------------------------------------------------------------------------

  Widget _buildSearchBar() {
    final isFocused = _focusNode.hasFocus;
    final hasText = _currentQuery.isNotEmpty;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isFocused
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isFocused
                      ? AppColors.dating.withOpacity(0.4)
                      : Colors.white.withOpacity(0.08),
                  width: isFocused ? 1.5 : 1,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.dating.withOpacity(0.12),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.search_rounded,
                    color: isFocused
                        ? AppColors.dating
                        : AppColors.grey2,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'ابحث بالاسم، المدينة، أو الاهتمام...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        isDense: true,
                      ),
                    ),
                  ),
                  if (hasText) ...[
                    GestureDetector(
                      onTap: _clearSearch,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.grey2,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  CATEGORY CHIPS
  // ---------------------------------------------------------------------------

  Widget _buildCategoryChips() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final isSelected = _selectedCategory == index;
            return _buildCategoryChip(_categories[index], isSelected, index);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => _onCategoryTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.dating, AppColors.neonRed],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.dating.withOpacity(0.3)
                : Colors.white.withOpacity(0.06),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.dating.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.grey2,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  BODY
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    // Active search with results or empty
    if (_currentQuery.isNotEmpty) {
      return _filteredProfiles.isEmpty
          ? _buildNoResultsState()
          : _buildSearchResults();
    }

    // Idle state - show suggestions, recent, trending
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Suggested for you
          if (_suggestedProfiles.isNotEmpty) ...[
            _buildSectionHeader(Icons.auto_awesome_rounded, 'مقترح لك',
                color: AppColors.neonYellow),
            const SizedBox(height: 12),
            _buildSuggestedProfiles(),
            const SizedBox(height: 28),
          ],

          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader(Icons.history_rounded, 'عمليات البحث الأخيرة'),
            const SizedBox(height: 12),
            _buildRecentSearches(),
            const SizedBox(height: 28),
          ],

          // Trending tags
          _buildSectionHeader(Icons.trending_up_rounded, 'رائج الآن',
              color: AppColors.neonGreen),
          const SizedBox(height: 12),
          _buildTrendingTags(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SEARCH RESULTS
  // ---------------------------------------------------------------------------

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Results count
        Container(
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_rounded,
                  color: AppColors.dating, size: 14),
              const SizedBox(width: 6),
              Text(
                '${_filteredProfiles.length} نتيجة لـ "$_currentQuery"',
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredProfiles.length,
            itemBuilder: (context, index) {
              return _buildResultCard(_filteredProfiles[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(DatingProfileModel profile, int index) {
    final matchPercent = 60 + Random().nextInt(35); // 60-95%
    final isOnline = index % 3 == 0;

    // Highlight matching text
    String _highlightMatch(String text) {
      if (_currentQuery.isEmpty) return text;
      final lowerText = text.toLowerCase();
      final lowerQuery = _currentQuery.toLowerCase();
      final matchIndex = lowerText.indexOf(lowerQuery);
      if (matchIndex == -1) return text;

      final before = text.substring(0, matchIndex);
      final match = text.substring(matchIndex, matchIndex + _currentQuery.length);
      final after = text.substring(matchIndex + _currentQuery.length);
      return '$before$match$after';
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _onProfileTap(profile),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              // Avatar with online indicator
              Stack(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.dating.withOpacity(0.2),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      image: profile.imageUrls.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(profile.imageUrls[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(
                        color: isOnline
                            ? AppColors.neonGreen
                            : Colors.white.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: profile.imageUrls.isEmpty
                        ? const Icon(Icons.person_rounded,
                            color: AppColors.grey2, size: 28)
                        : null,
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neonGreen,
                          border: Border.all(
                            color: AppColors.background,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name row
                    Row(
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${profile.age}',
                            style: TextStyle(
                              color: AppColors.grey2,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonBlue,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonBlue.withOpacity(0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 12),
                          ),
                        ],
                        const Spacer(),
                        // Match percentage
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.dating.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.dating.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite_rounded,
                                  color: AppColors.dating, size: 10),
                              const SizedBox(width: 3),
                              Text(
                                '$matchPercent%',
                                style: const TextStyle(
                                  color: AppColors.dating,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: AppColors.grey2, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          profile.city,
                          style: TextStyle(
                            color: AppColors.grey2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                              color: AppColors.grey2, fontSize: 10),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.distance,
                          style: TextStyle(
                            color: AppColors.grey2,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Interests
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: profile.interests.take(3).map((interest) {
                        final isMatch = _currentQuery.isNotEmpty &&
                            interest.toLowerCase()
                                .contains(_currentQuery.toLowerCase());
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isMatch
                                ? AppColors.dating.withOpacity(0.15)
                                : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isMatch
                                  ? AppColors.dating.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              color: isMatch
                                  ? AppColors.dating
                                  : AppColors.grey2,
                              fontSize: 11,
                              fontWeight: isMatch
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SUGGESTED PROFILES
  // ---------------------------------------------------------------------------

  Widget _buildSuggestedProfiles() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestedProfiles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, index) {
          final profile = _suggestedProfiles[index];
          return _buildSuggestedCard(profile, index);
        },
      ),
    );
  }

  Widget _buildSuggestedCard(DatingProfileModel profile, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.9 + (value * 0.1),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _onProfileTap(profile),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.03),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // Photo
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        profile.imageUrls.isNotEmpty
                            ? profile.imageUrls[0]
                            : '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.dating.withOpacity(0.15),
                                Colors.white.withOpacity(0.03),
                              ],
                            ),
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.grey2, size: 36),
                        ),
                      ),
                      // Bottom gradient
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Name overlay
                      Positioned(
                        bottom: 8,
                        left: 10,
                        right: 10,
                        child: Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Info
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: AppColors.grey2, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            profile.city,
                            style: TextStyle(
                              color: AppColors.grey2,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
    );
  }

  // ---------------------------------------------------------------------------
  //  RECENT SEARCHES
  // ---------------------------------------------------------------------------

  Widget _buildRecentSearches() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _recentSearches.map((search) {
        return GestureDetector(
          onTap: () => _onRecentSearchTap(search),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded,
                    color: AppColors.grey2, size: 14),
                const SizedBox(width: 6),
                Text(
                  search,
                  style: TextStyle(
                    color: AppColors.grey2,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  //  TRENDING TAGS
  // ---------------------------------------------------------------------------

  Widget _buildTrendingTags() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _trendingTags.map((tag) {
        final label = tag['label'] as String;
        final emoji = tag['emoji'] as String;
        final count = tag['count'] as String;

        return GestureDetector(
          onTap: () => _onTrendingTagTap(label),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$count بحث',
                      style: TextStyle(
                        color: AppColors.grey2,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  //  SECTION HEADER
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(IconData icon, String title,
      {Color? color}) {
    final effectiveColor = color ?? AppColors.dating;
    return Row(
      children: [
        Icon(icon, color: effectiveColor, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // Clear recent searches
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم مسح عمليات البحث الأخيرة'),
                backgroundColor: AppColors.background,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            'مسح',
            style: TextStyle(
              color: AppColors.grey2,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  EMPTY STATES
  // ---------------------------------------------------------------------------

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  color: AppColors.grey2,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'لا توجد نتائج',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'جرّب البحث بكلمات مختلفة أو غيّر تصنيف البحث',
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '"$_currentQuery"',
                style: TextStyle(
                  color: AppColors.dating.withOpacity(0.7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _clearSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.06),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'مسح البحث',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
