import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  late final PopupController _clusterPopupController;

  bool _ghostMode = false;
  bool _showFriends = true;
  bool _showHeatmap = false;
  bool _isAnimatingToFriend = false;
  bool _isSearchExpanded = false;

  int _selectedFriendIndex = -1;

  // ─── Mock Friend Data ───────────────────────────────────────────────
  final List<Map<String, dynamic>> _friends = [
    {
      'name': 'Sara',
      'lat': 36.7538,
      'lng': 3.0588,
      'bitmoji': '😎',
      'streak': 142,
      'distance': '0.2 km',
      'hasStory': true,
    },
    {
      'name': 'Ahmed',
      'lat': 36.7520,
      'lng': 3.0420,
      'bitmoji': '🎧',
      'streak': 89,
      'distance': '1.4 km',
      'hasStory': false,
    },
    {
      'name': 'Lina',      'lat': 36.7210,
      'lng': 3.1230,
      'bitmoji': '📚',
      'streak': 56,
      'distance': '4.8 km',
      'hasStory': true,
    },
    {
      'name': 'Omar',
      'lat': 36.7700,
      'lng': 3.0100,
      'bitmoji': '⚽',
      'streak': 210,
      'distance': '3.1 km',
      'hasStory': false,
    },
    {
      'name': 'Nour',
      'lat': 36.7100,
      'lng': 3.0800,
      'bitmoji': '🎬',
      'streak': 37,
      'distance': '5.2 km',
      'hasStory': true,
    },
    {
      'name': 'Yacine',
      'lat': 36.7600,
      'lng': 3.0900,
      'bitmoji': '🎮',
      'streak': 178,
      'distance': '0.8 km',
      'hasStory': false,
    },
    {
      'name': 'Amira',
      'lat': 36.7380,
      'lng': 3.0650,
      'bitmoji': '🌸',
      'streak': 95,
      'distance': '1.7 km',
      'hasStory': true,
    },
    {
      'name': 'Rami',
      'lat': 36.7450,
      'lng': 3.0350,
      'bitmoji': '🎸',
      'streak': 64,
      'distance': '2.3 km',      'hasStory': false,
    },
  ];

  // ─── Animation Controllers ──────────────────────────────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _clusterPopupController = PopupController();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ─── Actions ─────────────────────────────────────────────────────────
  void _onFriendAvatarTap(int index) {
    final friend = _friends[index];
    setState(() => _selectedFriendIndex = index);
    _isAnimatingToFriend = true;
    _mapController.move(
      LatLng(friend['lat'], friend['lng']),
      15.0,
    );
    // Reset highlight after a delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _selectedFriendIndex = -1);
        _isAnimatingToFriend = false;
      }
    });
  }

  void _showFriendPreview(Map<String, dynamic> friend) {    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _FriendBottomSheet(friend: friend),
    );
  }

  // ─── Markers ─────────────────────────────────────────────────────────
  List<Marker> _buildFriendMarkers() {
    return _friends.asMap().entries.map((entry) {
      final index = entry.key;
      final friend = entry.value;
      final isSelected = index == _selectedFriendIndex;

      return Marker(
        width: 90.0,
        height: 90.0,
        point: LatLng(friend['lat'], friend['lng']),
        anchorPos: AnchorPos.align(AnchorAlign.top),
        child: GestureDetector(
          onTap: () => _showFriendPreview(friend),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            transform: isSelected
                ? (Matrix4.identity()..scale(1.25))
                : Matrix4.identity(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Avatar Circle ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppColors.electricBlue,
                              AppColors.electricBlue.withOpacity(0.5),
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.black87,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.electricBlue
                          : AppColors.electricBlue.withOpacity(0.7),
                      width: isSelected ? 3 : 2,                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.electricBlue.withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF1A1A2E),
                    child: Text(
                      friend['bitmoji'] as String,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                // ── Name Label ──────────────────────────────────────
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.electricBlue.withOpacity(0.5)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    friend['name'] as String,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.electricBlue                          : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
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
      width: 40.0,
      height: 40.0,
      point: const LatLng(36.7538, 3.0588),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // ── Pulse Ring ───────────────────────────────────────
              Container(
                width: 40 * _pulseAnimation.value,
                height: 40 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.electricBlue
                      .withOpacity(0.15 * (1.4 - _pulseAnimation.value)),
                  border: Border.all(
                    color: AppColors.electricBlue.withOpacity(
                      0.3 * (1.4 - _pulseAnimation.value),
                    ),
                    width: 1.5,
                  ),
                ),
              ),
              // ── Center Dot ──────────────────────────────────────
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.electricBlue,
                  border: Border.all(                    color: AppColors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.electricBlue.withOpacity(0.5),
                      blurRadius: 10,
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

  // ─── Build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Map Layer ─────────────────────────────────────────────────
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
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.setrise',
              tileBuilder: _darkTileBuilder,
            ),

            // ── User Location Marker ───────────────────────────────
            if (!_ghostMode) MarkerLayer(markers: [_buildUserMarker()]),

            // ── Friend Cluster Markers ─────────────────────────────
            if (_showFriends && !_ghostMode)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(                  popupController: _clusterPopupController,
                  maxClusterRadius: 50,
                  size: const Size(44, 44),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 15.0,
                  markers: _buildFriendMarkers(),
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.electricBlue,
                            AppColors.electricBlue.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: AppColors.white,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.electricBlue.withOpacity(0.4),
                            blurRadius: 14,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // ── Heatmap Layer ──────────────────────────────────────
            if (_showHeatmap)
              Positioned.fill(
                child: Container(                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.3, -0.3),
                      radius: 2.0,
                      colors: [
                        AppColors.electricBlue.withOpacity(0.3),
                        AppColors.electricBlue.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

            // ── Ghost Mode Overlay ─────────────────────────────────
            if (_ghostMode)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: AppColors.background.withOpacity(0.55),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.grey.withOpacity(0.2),
                              border: Border.all(
                                color: AppColors.grey2.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.visibility_off,
                              color: AppColors.grey2,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ghost Mode is ON',
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.grey2,
                            ),
                          ),
                          const SizedBox(height: 6),                          Text(
                            'Your location is hidden from friends',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // ── Top Bar: Search and Toggle Chips ──────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search Bar ─────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _isSearchExpanded ? 48 : 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.search,
                        color: AppColors.grey2,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      if (_isSearchExpanded)
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search places or friends',
                              hintStyle: AppTextStyles.body2.copyWith(
                                color: AppColors.grey2,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(                                vertical: 12,
                              ),
                            ),
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearchExpanded = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                'Search places or friends',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.grey2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_isSearchExpanded)
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppColors.grey2,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSearchExpanded = false;
                            });
                          },
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ── Location Label ─────────────────────────────────
                Container(                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.electricBlue,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Algiers, Algeria',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _ghostMode 
                              ? AppColors.neonRed.withOpacity(0.2) 
                              : AppColors.electricBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _ghostMode 
                                ? AppColors.neonRed 
                                : AppColors.electricBlue,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _ghostMode ? 'Hidden' : 'Sharing',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _ghostMode 
                                ? AppColors.neonRed 
                                : AppColors.electricBlue,
                            fontWeight: FontWeight.w600,
                          ),                        ),
                      ),
                    ],
                  ),
                ),

                // ── Toggle Chips Row ───────────────────────────────
                Row(
                  children: [
                    _buildToggleChip(
                      label: 'Ghost Mode',
                      icon: Icons.visibility_off,
                      isActive: _ghostMode,
                      onTap: () =>
                          setState(() => _ghostMode = !_ghostMode),
                    ),
                    const SizedBox(width: 10),
                    _buildToggleChip(
                      label: 'Friends',
                      icon: Icons.people,
                      isActive: _showFriends,
                      onTap: () =>
                          setState(() => _showFriends = !_showFriends),
                    ),
                    const SizedBox(width: 10),
                    _buildToggleChip(
                      label: 'Heatmap',
                      icon: Icons.terrain,
                      isActive: _showHeatmap,
                      onTap: () =>
                          setState(() => _showHeatmap = !_showHeatmap),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Friend Zoom Controls ──────────────────────────────────────
        if (!_ghostMode)
          Positioned(
            right: 12,
            bottom: 130,
            child: Column(
              children: [
                _mapControlButton(
                  icon: Icons.my_location,
                  onTap: () {
                    _mapController.move(                      const LatLng(36.7538, 3.0588),
                      14.0,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _mapControlButton(
                  icon: Icons.zoom_in,
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (currentZoom + 1).clamp(3.0, 18.0),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _mapControlButton(
                  icon: Icons.zoom_out,
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (currentZoom - 1).clamp(3.0, 18.0),
                    );
                  },
                ),
              ],
            ),
          ),

        // ── Bottom Friend Avatars Bar ─────────────────────────────────
        if (!_ghostMode)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withOpacity(0.85),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),              padding: const EdgeInsets.only(
                top: 24,
                bottom: 12,
                left: 8,
                right: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Friends Count ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.electricBlue,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.electricBlue
                                      .withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_friends.length} friends nearby',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Avatar List ──────────────────────────────────
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: _friends.length,                      itemBuilder: (context, index) {
                        final friend = _friends[index];
                        final isSelected =
                            index == _selectedFriendIndex;
                        final hasStory = friend['hasStory'] as bool;

                        return GestureDetector(
                          onTap: () => _onFriendAvatarTap(index),
                          child: Container(
                            width: 68,
                            margin: const EdgeInsets.only(right: 6),
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 250),
                                  curve: Curves.easeOutBack,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              AppColors.electricBlue,
                                              AppColors.electricBlue
                                                  .withOpacity(0.4),
                                            ],
                                          )
                                        : hasStory
                                            ? const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  AppColors.electricBlue,
                                                  AppColors.music,
                                                ],
                                              )
                                            : null,
                                    color: isSelected
                                        ? null
                                        : hasStory
                                            ? null
                                            : AppColors.grey.withOpacity(0.2),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.electricBlue
                                          : hasStory
                                              ? AppColors.electricBlue
                                              : AppColors.electricBlue
                                                  .withOpacity(0.4),                                      width: isSelected ? 3 : hasStory ? 2 : 1.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.electricBlue
                                                  .withOpacity(0.35),
                                              blurRadius: 12,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                        const Color(0xFF1A1A2E),
                                    child: Text(
                                      friend['bitmoji'] as String,
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  friend['name'] as String,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: isSelected
                                        ? AppColors.electricBlue
                                        : AppColors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                  maxLines: 1,
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
    );  }

  // ─── Tile Builder (dark overlay for style) ──────────────────────────
  Widget _darkTileBuilder(BuildContext context, Widget tileWidget, Tile tile) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(<double>[
        0.3, 0.3, 0.3, 0, 0,
        0.3, 0.3, 0.3, 0, 0,
        0.3, 0.3, 0.3, 0, 0,
        0.0, 0.0, 0.0, 0.6, 0,
      ]),
      child: tileWidget,
    );
  }

  // ─── Toggle Chip ─────────────────────────────────────────────────────
  Widget _buildToggleChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    AppColors.electricBlue,
                    AppColors.electricBlue.withOpacity(0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive
                ? AppColors.electricBlue
                : AppColors.grey2.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(                    color: AppColors.electricBlue.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.white : AppColors.grey2,
              size: 15,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isActive ? AppColors.white : AppColors.grey2,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Map Control Button ─────────────────────────────────────────────
  Widget _mapControlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.grey2.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: 20,
        ),
      ),    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  Friend Bottom Sheet
// ═══════════════════════════════════════════════════════════════════════

class _FriendBottomSheet extends StatelessWidget {
  final Map<String, dynamic> friend;

  const _FriendBottomSheet({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ────────────────────────────────────────────────
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.grey2.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Friend Header ─────────────────────────────────────────
            Row(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: friend['hasStory'] 
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [                              AppColors.electricBlue,
                              AppColors.music,
                            ],
                          )
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF1A1A2E),
                    child: Text(
                      friend['bitmoji'] as String,
                      style: const TextStyle(fontSize: 34),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend['name'] as String,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 13,
                            color: AppColors.grey2,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Last seen: now',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Streak Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.electricBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.electricBlue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${friend['streak']}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Distance Info ─────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.15),
                  width: 1,
                ),              ),
              child: Row(
                children: [
                  Icon(
                    Icons.straighten,
                    size: 16,
                    color: AppColors.grey2,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${friend['distance']} away',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.grey2,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.near_me,
                    size: 16,
                    color: AppColors.electricBlue.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'View on map',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.electricBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ── Action Buttons ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    context: context,
                    icon: Icons.chat_bubble_rounded,
                    label: 'Chat',
                    color: AppColors.electricBlue,
                    onTap: () => Navigator.pop(context),
                  ),
                  _actionButton(
                    context: context,
                    icon: Icons.person_add_rounded,
                    label: 'Friend',                    color: Colors.orange,
                    onTap: () => Navigator.pop(context),
                  ),
                  _actionButton(
                    context: context,
                    icon: Icons.navigation_rounded,
                    label: 'Navigate',
                    color: Colors.green,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
              border: Border.all(
                color: color.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(              color: AppColors.grey2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
