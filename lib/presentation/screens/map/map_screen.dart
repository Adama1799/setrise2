// lib/presentation/screens/map/map_screen.dart
// ✅ FIXED: Removed deprecated PopupController
// ✅ FIXED: Added iPhone 17 Pro Max glassmorphism style
// ✅ FIXED: MarkerClusterLayerWidget updated to current API

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final MapController _mapController;
  // ✅ FIX: PopupController removed — deprecated in flutter_map_marker_cluster ^1.3.0

  bool _ghostMode = false;
  bool _showFriends = true;
  bool _showHeatmap = false;
  int _selectedFriendIndex = -1;

  final List<Map<String, dynamic>> _friends = [
    {'name': 'Sara',   'lat': 36.7538, 'lng': 3.0588, 'bitmoji': '😎', 'streak': 142, 'distance': '0.2 km', 'hasStory': true},
    {'name': 'Ahmed',  'lat': 36.7520, 'lng': 3.0420, 'bitmoji': '🎧', 'streak': 89,  'distance': '1.4 km', 'hasStory': false},
    {'name': 'Lina',   'lat': 36.7210, 'lng': 3.1230, 'bitmoji': '📚', 'streak': 56,  'distance': '4.8 km', 'hasStory': true},
    {'name': 'Omar',   'lat': 36.7700, 'lng': 3.0100, 'bitmoji': '⚽', 'streak': 210, 'distance': '3.1 km', 'hasStory': false},
    {'name': 'Nour',   'lat': 36.7100, 'lng': 3.0800, 'bitmoji': '🎬', 'streak': 37,  'distance': '5.2 km', 'hasStory': true},
    {'name': 'Yacine', 'lat': 36.7600, 'lng': 3.0900, 'bitmoji': '🎮', 'streak': 178, 'distance': '0.8 km', 'hasStory': false},
    {'name': 'Amira',  'lat': 36.7380, 'lng': 3.0650, 'bitmoji': '🌸', 'streak': 95,  'distance': '1.7 km', 'hasStory': true},
    {'name': 'Rami',   'lat': 36.7450, 'lng': 3.0350, 'bitmoji': '🎸', 'streak': 64,  'distance': '2.3 km', 'hasStory': false},
  ];

  late AnimationController _pulseController;
  late Animation<double>   _pulseAnimation;
  late AnimationController _ghostController;
  late Animation<double>   _ghostAnimation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _ghostController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ghostAnimation = CurvedAnimation(parent: _ghostController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    _ghostController.dispose();
    super.dispose();
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  void _onFriendAvatarTap(int index) {
    HapticFeedback.selectionClick();
    final friend = _friends[index];
    setState(() => _selectedFriendIndex = index);
    _mapController.move(LatLng(friend['lat'] as double, friend['lng'] as double), 15.5);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _selectedFriendIndex = -1);
    });
  }

  void _toggleGhostMode() {
    HapticFeedback.mediumImpact();
    setState(() => _ghostMode = !_ghostMode);
    if (_ghostMode) {
      _ghostController.forward();
    } else {
      _ghostController.reverse();
    }
  }

  void _showFriendPreview(Map<String, dynamic> friend) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _FriendBottomSheet(friend: friend),
    );
  }

  // ── Markers ──────────────────────────────────────────────────────────────

  List<Marker> _buildFriendMarkers() {
    if (!_showFriends || _ghostMode) return [];
    return _friends.asMap().entries.map((entry) {
      final index  = entry.key;
      final friend = entry.value;
      final isSelected = index == _selectedFriendIndex;
      final hasStory   = friend['hasStory'] as bool;

      return Marker(
        width: 92,
        height: 92,
        point: LatLng(friend['lat'] as double, friend['lng'] as double),
        child: GestureDetector(
          onTap: () => _showFriendPreview(friend),
          child: AnimatedScale(
            scale: isSelected ? 1.18 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar ring
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasStory
                        ? const LinearGradient(
                            colors: [Color(0xFF007AFF), Color(0xFF00C6FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: hasStory ? null : const Color(0xFF2C2C2C),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected ? AppColors.primary : Colors.black)
                            .withOpacity(0.35),
                        blurRadius: isSelected ? 16 : 6,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF1A1A1A),
                    child: Text(
                      friend['bitmoji'] as String,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Name tag — glassmorphism
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      color: Colors.black.withOpacity(0.45),
                      child: Text(
                        friend['name'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Marker _buildUserMarker() {
    return Marker(
      width: 56,
      height: 56,
      point: const LatLng(36.7538, 3.0588),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              Container(
                width: 56 * (_pulseAnimation.value / 1.5),
                height: 56 * (_pulseAnimation.value / 1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(
                    0.15 * (1.5 - _pulseAnimation.value + 1),
                  ),
                ),
              ),
              // Outer ring
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.25),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
                ),
              ),
              // Core dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // ── Map layer ────────────────────────────────────────────────────────
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(36.7538, 3.0588),
            initialZoom: 12.0,
            maxZoom: 18.0,
            minZoom: 3.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            // Dark tile filter (AMOLED map style)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.setrise.app',
              tileBuilder: (context, tileWidget, tile) => ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  -0.7,  0.0,  0.0, 0, 180,
                   0.0, -0.7,  0.0, 0, 180,
                   0.0,  0.0, -0.7, 0, 180,
                   0.0,  0.0,  0.0, 1,   0,
                ]),
                child: tileWidget,
              ),
            ),

            // User location marker
            if (!_ghostMode)
              MarkerLayer(markers: [_buildUserMarker()]),

            // Friend cluster layer
            // ✅ FIX: No PopupController — uses builder pattern only
            if (_showFriends && !_ghostMode)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 55,
                  size: const Size(44, 44),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 15,
                  markers: _buildFriendMarkers(),
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 14,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),

        // ── Ghost overlay ─────────────────────────────────────────────────
        if (_ghostMode)
          AnimatedBuilder(
            animation: _ghostAnimation,
            builder: (context, child) => Opacity(
              opacity: _ghostAnimation.value,
              child: child,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0.55),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                        ),
                        child: const Icon(CupertinoIcons.eye_slash, color: Colors.white, size: 44),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Ghost Mode',
                        style: AppTextStyles.h4.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your location is hidden from everyone',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // ── Top controls ─────────────────────────────────────────────────
        Positioned(
          top: topPadding + 56, // below TopBar
          left: 16,
          right: 16,
          child: Column(
            children: [
              // Search bar — glassmorphism
              _GlassBar(
                child: Row(
                  children: [
                    Icon(CupertinoIcons.search, color: Colors.white54, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search places or friends…',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white38,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Toggle chips row
              Row(
                children: [
                  _GlassChip(
                    label: 'Ghost',
                    icon: CupertinoIcons.eye_slash,
                    isActive: _ghostMode,
                    activeColor: const Color(0xFF8E8E93),
                    onTap: _toggleGhostMode,
                  ),
                  const SizedBox(width: 8),
                  _GlassChip(
                    label: 'Friends',
                    icon: CupertinoIcons.person_2,
                    isActive: _showFriends,
                    activeColor: AppColors.primary,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _showFriends = !_showFriends);
                    },
                  ),
                  const SizedBox(width: 8),
                  _GlassChip(
                    label: 'Heatmap',
                    icon: CupertinoIcons.map,
                    isActive: _showHeatmap,
                    activeColor: const Color(0xFFFF6B35),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _showHeatmap = !_showHeatmap);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Map control buttons ───────────────────────────────────────────
        if (!_ghostMode)
          Positioned(
            right: 16,
            bottom: 160,
            child: Column(
              children: [
                _MapControlBtn(
                  icon: CupertinoIcons.location_fill,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _mapController.move(const LatLng(36.7538, 3.0588), 14.5);
                  },
                ),
                const SizedBox(height: 8),
                _MapControlBtn(
                  icon: CupertinoIcons.plus,
                  onTap: () {
                    final z = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (z + 1).clamp(3.0, 18.0),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _MapControlBtn(
                  icon: CupertinoIcons.minus,
                  onTap: () {
                    final z = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (z - 1).clamp(3.0, 18.0),
                    );
                  },
                ),
              ],
            ),
          ),

        // ── Friends tray (bottom) ─────────────────────────────────────────
        if (!_ghostMode)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 28, bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, left: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_friends.length} friends nearby',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 84,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        final friend = _friends[index];
                        final isSelected = index == _selectedFriendIndex;
                        final hasStory = friend['hasStory'] as bool;

                        return GestureDetector(
                          onTap: () => _onFriendAvatarTap(index),
                          child: Container(
                            width: 64,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOut,
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isSelected || hasStory
                                        ? LinearGradient(
                                            colors: isSelected
                                                ? [Colors.white, AppColors.primary]
                                                : [
                                                    const Color(0xFF007AFF),
                                                    const Color(0xFF00C6FF),
                                                  ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: (!isSelected && !hasStory)
                                        ? const Color(0xFF3A3A3C)
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.5),
                                              blurRadius: 14,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: const Color(0xFF1C1C1E),
                                    child: Text(
                                      friend['bitmoji'] as String,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  friend['name'] as String,
                                  style: AppTextStyles.caption.copyWith(
                                    color: isSelected ? Colors.white : Colors.white60,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Glass Widgets ────────────────────────────────────────────────────────────

class _GlassBar extends StatelessWidget {
  final Widget child;
  const _GlassBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _GlassChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withOpacity(0.22)
              : Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive
                ? activeColor.withOpacity(0.55)
                : Colors.white.withOpacity(0.12),
            width: 1,
          ),
          boxShadow: isActive
              ? [BoxShadow(color: activeColor.withOpacity(0.2), blurRadius: 10)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : Colors.white54,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? activeColor : Colors.white54,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

// ─── Friend Bottom Sheet ──────────────────────────────────────────────────────

class _FriendBottomSheet extends StatelessWidget {
  final Map<String, dynamic> friend;
  const _FriendBottomSheet({required this.friend});

  @override
  Widget build(BuildContext context) {
    final hasStory = friend['hasStory'] as bool;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E).withOpacity(0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.10)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Profile row
              Row(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasStory
                          ? const LinearGradient(
                              colors: [Color(0xFF007AFF), Color(0xFF00C6FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: hasStory ? null : const Color(0xFF3A3A3C),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF1A1A1A),
                      child: Text(
                        friend['bitmoji'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend['name'] as String,
                          style: AppTextStyles.h4.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(CupertinoIcons.time, size: 13, color: Colors.white38),
                            const SizedBox(width: 4),
                            Text(
                              'Active now',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFF34C759),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Streak badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F0A).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF9F0A).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.flame, color: Color(0xFFFF9F0A), size: 15),
                        const SizedBox(width: 4),
                        Text(
                          '${friend['streak']}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: const Color(0xFFFF9F0A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Distance pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.location, size: 15, color: Colors.white38),
                    const SizedBox(width: 8),
                    Text(
                      '${friend['distance']} away',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
                    ),
                    const Spacer(),
                    Text(
                      'View on map',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionBtn(
                    icon: CupertinoIcons.chat_bubble_fill,
                    label: 'Message',
                    color: AppColors.primary,
                    onTap: () => Navigator.pop(context),
                  ),
                  _ActionBtn(
                    icon: CupertinoIcons.person_badge_plus_fill,
                    label: 'Friend',
                    color: const Color(0xFF34C759),
                    onTap: () => Navigator.pop(context),
                  ),
                  _ActionBtn(
                    icon: CupertinoIcons.location_fill,
                    label: 'Navigate',
                    color: const Color(0xFFFF9F0A),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.14),
              border: Border.all(color: color.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.18), blurRadius: 12),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
