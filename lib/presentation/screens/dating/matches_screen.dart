import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/dating_provider.dart';

// =============================================================================
//  MATCH MODEL EXTENSION (Helper)
// =============================================================================

extension MatchTimeHelper on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return '${diff.inMinutes} د';
    if (diff.inHours < 24) return '${diff.inHours} س';
    if (diff.inDays < 7) return '${diff.inDays} يوم';
    return '${(diff.inDays / 7).floor()} أسبوع';
  }
}

// =============================================================================
//  MATCHES SCREEN
// =============================================================================

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen>
    with TickerProviderStateMixin {
  // --- Tab state ---
  int _selectedTab = 0;
  final List<String> _tabs = ['الكل', 'جديد', 'رسائل'];

  // --- Search ---
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  // --- Animation ---
  late AnimationController _entryController;
  late AnimationController _tabIndicatorController;
  late Animation<double> _fadeAnimation;

  // --- Scroll ---
  final ScrollController _scrollController = ScrollController();
  bool _showNewMatchBadge = true;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _tabIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _tabIndicatorController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  LOGIC
  // =========================================================================

  void _onTabChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedTab = index);
    _tabIndicatorController.forward(from: 0);
    _entryController.forward(from: 0);
  }

  void _toggleSearch() {
    HapticFeedback.selectionClick();
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  // --- Categorize matches by time ---
  Map<String, List<dynamic>> _categorizeMatches(List<dynamic> matches) {
    final now = DateTime.now();
    final today = <dynamic>[];
    final thisWeek = <dynamic>[];
    final earlier = <dynamic>[];

    for (final match in matches) {
      // Use mock time categorization since we don't have real timestamps
      final idx = matches.indexOf(match);
      if (idx < 3) {
        today.add(match);
      } else if (idx < 6) {
        thisWeek.add(match);
      } else {
        earlier.add(match);
      }
    }

    return {
      'اليوم': today,
      'هذا الأسبوع': thisWeek,
      'سابقاً': earlier,
    };
  }

  // --- Filter matches by tab and search ---
  List<dynamic> _getFilteredMatches(List<dynamic> matches) {
    var filtered = matches;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((m) {
        final name = (m.name as String).toLowerCase();
        final location = (m.location as String).toLowerCase();
        return name.contains(_searchQuery) ||
            location.contains(_searchQuery);
      }).toList();
    }

    // Tab filter is handled in build via categorization
    return filtered;
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final matches = ref.watch(datingProvider).matches;
    final filteredMatches = _getFilteredMatches(matches);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom app bar
          _buildAppBar(matches.length),

          // Tab bar
          _buildTabBar(),

          // Search bar (animated)
          if (_isSearching) _buildSearchBar(),

          // Content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: matches.isEmpty
                  ? _buildEmptyState()
                  : filteredMatches.isEmpty
                      ? _buildNoResultsState()
                      : _buildMatchesList(filteredMatches),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  APP BAR
  // ---------------------------------------------------------------------------

  Widget _buildAppBar(int matchCount) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.of(context).padding.top + 8,
        8,
        0,
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.dateColor, Colors.amber],
                    ).createShader(bounds),
                    child: const Text(
                      'المتطابقون',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                // Match count badge
                if (matchCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.dateColor.withOpacity(0.15),
                          Colors.amber.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.dateColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_rounded,
                            color: AppColors.dateColor, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          '$matchCount',
                          style: const TextStyle(
                            color: AppColors.dateColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(width: 8),

                // Search toggle
                GestureDetector(
                  onTap: _toggleSearch,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isSearching
                          ? AppColors.dateColor.withOpacity(0.15)
                          : Colors.white.withOpacity(0.06),
                      border: _isSearching
                          ? Border.all(
                              color: AppColors.dateColor.withOpacity(0.3))
                          : null,
                    ),
                    child: Icon(
                      _isSearching
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                      color: _isSearching
                          ? AppColors.dateColor
                          : Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  TAB BAR
  // ---------------------------------------------------------------------------

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          final label = _tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => _onTabChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [
                            AppColors.dateColor,
                            Colors.amber,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.dateColor.withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (index == 1 && _showNewMatchBadge) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.dateColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textTertiary,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SEARCH BAR
  // ---------------------------------------------------------------------------

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded,
              color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث في المتطابقين...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  MATCHES LIST
  // ---------------------------------------------------------------------------

  Widget _buildMatchesList(List<dynamic> matches) {
    if (_selectedTab == 0) {
      // "All" tab - categorized
      final categories = _categorizeMatches(matches);
      return _buildCategorizedList(categories);
    } else if (_selectedTab == 1) {
      // "New" tab - first 3
      final newMatches = matches.length > 3 ? matches.sublist(0, 3) : matches;
      return _buildMatchGrid(newMatches);
    } else {
      // "Messages" tab
      return _buildMessagesList(matches);
    }
  }

  Widget _buildCategorizedList(Map<String, List<dynamic>> categories) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        // Stats summary
        _buildStatsSummary(categories),
        const SizedBox(height: 24),

        // Categories
        ...categories.entries.expand((entry) {
          final title = entry.key;
          final items = entry.value;
          if (items.isEmpty) return <Widget>[];
          return [
            _buildCategoryHeader(title, items.length),
            const SizedBox(height: 12),
            _buildMatchGrid(items),
            const SizedBox(height: 24),
          ];
        }),
      ],
    );
  }

  Widget _buildStatsSummary(Map<String, List<dynamic>> categories) {
    final total = categories.values.fold<int>(
        0, (sum, list) => sum + list.length);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.dateColor.withOpacity(0.08),
              Colors.amber.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.dateColor.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.dateColor.withOpacity(0.2),
                    Colors.amber.withOpacity(0.15),
                  ],
                ),
                border: Border.all(
                  color: AppColors.dateColor.withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.dateColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ملخص المتطابقين',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'لديك $total متطابق إجمالاً - ${categories['اليوم']?.length ?? 0} اليوم',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Action
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('استمر في التمرير لاكتشاف المزيد! 💛'),
                    backgroundColor: AppColors.dateColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.dateColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'استكشف',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  MATCH GRID
  // ---------------------------------------------------------------------------

  Widget _buildMatchGrid(List<dynamic> matches) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: matches.length,
      itemBuilder: (_, index) {
        return _buildMatchCard(matches[index], index);
      },
    );
  }

  Widget _buildMatchCard(dynamic match, int index) {
    final isOnline = index % 3 == 0; // Mock online status
    final isSuperMatch = index == 0; // First match is super match
    final isVerified = index % 2 == 0; // Mock verified

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
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
        onTap: () => _onMatchTap(match),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surface,
            border: isSuperMatch
                ? Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              if (isSuperMatch)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // Image section
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Photo
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(
                          match.photos.isNotEmpty ? match.photos[0] : '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.dateColor.withOpacity(0.2),
                                  AppColors.surface,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 56,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ),

                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Online indicator
                      if (isOnline)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle,
                                    color: AppColors.dateColor, size: 8),
                                SizedBox(width: 4),
                                Text(
                                  'متصل',
                                  style: TextStyle(
                                    color: AppColors.dateColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Super match badge
                      if (isSuperMatch)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber,
                                  Colors.orange,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 3),
                                Text(
                                  'Super Match',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Bottom name overlay
                      Positioned(
                        bottom: 10,
                        left: 12,
                        right: 12,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${match.name}, ${match.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isVerified)
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.dateColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.dateColor.withOpacity(0.4),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Info section
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location with icon
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.textTertiary,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                match.location,
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Message button
                        SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: () => _onMessageTap(match),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSuperMatch
                                  ? Colors.amber
                                  : AppColors.dateColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_rounded, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'رسالة',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  MESSAGES LIST (for "Messages" tab)
  // ---------------------------------------------------------------------------

  Widget _buildMessagesList(List<dynamic> matches) {
    if (matches.isEmpty) {
      return _buildEmptyState(subtitle: 'ابدأ محادثة مع متطابقيك!');
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      itemCount: matches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (_, index) {
        return _buildMessageRow(matches[index], index);
      },
    );
  }

  Widget _buildMessageRow(dynamic match, int index) {
    final isOnline = index % 3 == 0;
    final lastMessages = [
      'مرحباً! كيف حالك؟ 😊',
      'شكراً لك!',
      'هل تريد اللقاء؟',
      'صورتك جميلة جداً!',
      'ما هي اهتماماتك؟',
      'أحب السفر أيضاً ✈️',
    ];
    final lastMessage = lastMessages[index % lastMessages.length];
    final times = ['الآن', '5 د', '30 د', '1 س', '3 س', '1 يوم'];
    final time = times[index % times.length];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _onMatchTap(match),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: index == 0
                ? AppColors.dateColor.withOpacity(0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: index == 0
                ? Border.all(
                    color: AppColors.dateColor.withOpacity(0.15))
                : null,
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.dateColor.withOpacity(0.3),
                          Colors.amber.withOpacity(0.2),
                        ],
                      ),
                      image: match.photos.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(match.photos[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(
                        color: isOnline
                            ? AppColors.dateColor
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  // Online dot
                  if (isOnline)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.dateColor,
                          border: Border.all(
                            color: AppColors.background,
                            width: 2.5,
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
                    Row(
                      children: [
                        Text(
                          match.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${match.age}',
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          time,
                          style: TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Unread indicator (mock)
              if (index < 2)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.dateColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dateColor.withOpacity(0.4),
                        blurRadius: 6,
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
  //  EMPTY STATES
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState({String? subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated heart
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.dateColor.withOpacity(0.08),
                    border: Border.all(
                      color: AppColors.dateColor.withOpacity(0.15),
                    ),
                  ),
                  child: const Text(
                    '💛',
                    style: TextStyle(fontSize: 56),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'لا يوجد متطابقون بعد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle ?? 'استمر في التمرير للعثور على أشخاص مميزين!',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dateColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'ابدأ التمرير',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded),
                      color: Colors.white.withOpacity(0.7),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  color: AppColors.textTertiary,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد نتائج',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'جرّب كلمات بحث مختلفة',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  ACTIONS
  // ---------------------------------------------------------------------------

  void _onMatchTap(dynamic match) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to chat or profile detail
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح محادثة مع ${match.name} 💬'),
        backgroundColor: AppColors.dateColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onMessageTap(dynamic match) {
    HapticFeedback.mediumImpact();
    // TODO: Navigate to chat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('بدء محادثة مع ${match.name} 💬'),
        backgroundColor: AppColors.dateColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
