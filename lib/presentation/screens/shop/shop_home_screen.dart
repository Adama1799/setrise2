// lib/presentation/screens/shop/shop_home_screen.dart
// ✅ FIXED: Replaced flutter_riverpod (not in pubspec) with StatefulWidget temporarily
// ✅ FIXED: Replaced app_typography with app_text_styles (correct path)
// ✅ FIXED: Removed cached_network_image (add to pubspec first, then re-enable)
// ✅ FIXED: formatters.dart now exists at lib/core/utils/formatters.dart
// ✅ STYLE: iPhone 17 Pro Max — large title, glassmorphism, liquid cards

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';

// ── Simple mock data (replace with real models later) ──────────────────────────
class _Product {
  final String id;
  final String name;
  final String seller;
  final double price;
  final double rating;
  final int reviews;
  final String emoji;
  final Color color;
  bool isFavorite;

  _Product({
    required this.id,
    required this.name,
    required this.seller,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.emoji,
    required this.color,
    this.isFavorite = false,
  });
}

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  bool _isSearchFocused = false;
  int _selectedCategoryIndex = 0;
  bool _isLoading = false;

  final List<String> _categories = [
    'All', 'Fashion', 'Tech', 'Beauty', 'Food', 'Sport', 'Home', 'Art',
  ];

  final List<String> _categoryEmojis = [
    '🛒', '👗', '💻', '💄', '🍕', '⚽', '🏠', '🎨',
  ];

  final List<_Product> _products = [
    _Product(id: '1', name: 'Air Pro Headphones',  seller: 'SoundLab',    price: 12500, rating: 4.8, reviews: 1240, emoji: '🎧', color: const Color(0xFF1C1C2E), isFavorite: true),
    _Product(id: '2', name: 'Vintage Denim Jacket', seller: 'UrbanDzair',  price: 4200,  rating: 4.6, reviews: 856,  emoji: '👕', color: const Color(0xFF1A2C1A)),
    _Product(id: '3', name: 'Smart Watch Series 7', seller: 'TechAlgeria', price: 32000, rating: 4.9, reviews: 3210, emoji: '⌚', color: const Color(0xFF2C1A1A), isFavorite: true),
    _Product(id: '4', name: 'Glow Serum Kit',       seller: 'BeautyDz',    price: 2800,  rating: 4.5, reviews: 672,  emoji: '✨', color: const Color(0xFF2C2A1A)),
    _Product(id: '5', name: 'Running Shoes Pro',    seller: 'SportDz',     price: 6500,  rating: 4.7, reviews: 1890, emoji: '👟', color: const Color(0xFF1A1A2C)),
    _Product(id: '6', name: 'Espresso Machine',     seller: 'CafeDz',      price: 18000, rating: 4.4, reviews: 445,  emoji: '☕', color: const Color(0xFF2C1A2C)),
  ];

  List<_Product> get _filteredProducts {
    if (_selectedCategoryIndex == 0) return _products;
    // Category filter placeholder (connect to real data)
    return _products;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedCategoryIndex = _tabController.index);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleFavorite(int index) {
    HapticFeedback.impactOccurred(HapticFeedbackType.lightImpact);
    setState(() => _filteredProducts[index].isFavorite = !_filteredProducts[index].isFavorite);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Large Title App Bar ─────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 130,
          pinned: true,
          stretch: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF010101),
                    const Color(0xFF010101).withOpacity(0.95),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shop',
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Row(
                            children: [
                              _TopBarBtn(
                                icon: CupertinoIcons.bell,
                                badge: true,
                                onTap: () {},
                              ),
                              const SizedBox(width: 8),
                              _TopBarBtn(
                                icon: CupertinoIcons.bag,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search bar
                      _SearchBar(
                        controller: _searchController,
                        onFocusChanged: (f) => setState(() => _isSearchFocused = f),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Category tabs ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isActive = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedCategoryIndex = index);
                    _tabController.animateTo(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.10),
                      ),
                      boxShadow: isActive
                          ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10)]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _categoryEmojis[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _categories[index],
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive ? Colors.white : Colors.white54,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // ── Promo banner ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _PromoBanner(),
          ),
        ),

        // ── Section title ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured',
                  style: AppTextStyles.h5.copyWith(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'See All',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Product grid ─────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = _filteredProducts[index];
                return _ProductCard(
                  product: product,
                  onFavorite: () => _toggleFavorite(index),
                  onTap: () {},
                );
              },
              childCount: _filteredProducts.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<bool> onFocusChanged;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.onFocusChanged,
    required this.onChanged,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => widget.onFocusChanged(_focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.09),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Icon(CupertinoIcons.search, color: Colors.white38, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  onChanged: widget.onChanged,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search products…',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white30),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (widget.controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.white30, size: 18),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Promo Banner ─────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF00C6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '⚡ Flash Sale',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Up to 50% OFF',
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ends in 2h 34m',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Shop Now',
                style: AppTextStyles.labelSmall.copyWith(
                  color: const Color(0xFF007AFF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final _Product product;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: product.color,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image area
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              shape: BoxShape.circle,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                product.isFavorite
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                key: ValueKey(product.isFavorite),
                                color: product.isFavorite
                                    ? const Color(0xFFFF2D55)
                                    : Colors.white60,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.seller,
                    style: AppTextStyles.caption.copyWith(color: Colors.white38),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // ✅ Using formatters.dart (now exists)
                        Formatters.formatPrice(product.price),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.star_fill, color: Color(0xFFFFCC00), size: 11),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar Button ───────────────────────────────────────────────────────────

class _TopBarBtn extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;

  const _TopBarBtn({required this.icon, this.badge = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ),
          if (badge)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF3B30),
                  border: Border.all(color: const Color(0xFF010101), width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
