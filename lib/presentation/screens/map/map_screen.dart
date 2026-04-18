// lib/presentation/screens/map/map_screen.dart
import 'dart:async';
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
  final PopupController _clusterPopupController = PopupController();

  bool _ghostMode = false;
  bool _showFriends = true;
  bool _showHeatmap = false;
  int _selectedFriendIndex = -1;

  final List<Map<String, dynamic>> _friends = [
    {'name': 'Sara', 'lat': 36.7538, 'lng': 3.0588, 'bitmoji': '😎', 'streak': 142, 'distance': '0.2 km', 'hasStory': true},
    {'name': 'Ahmed', 'lat': 36.7520, 'lng': 3.0420, 'bitmoji': '🎧', 'streak': 89, 'distance': '1.4 km', 'hasStory': false},
    {'name': 'Lina', 'lat': 36.7210, 'lng': 3.1230, 'bitmoji': '📚', 'streak': 56, 'distance': '4.8 km', 'hasStory': true},
    {'name': 'Omar', 'lat': 36.7700, 'lng': 3.0100, 'bitmoji': '⚽', 'streak': 210, 'distance': '3.1 km', 'hasStory': false},
    {'name': 'Nour', 'lat': 36.7100, 'lng': 3.0800, 'bitmoji': '🎬', 'streak': 37, 'distance': '5.2 km', 'hasStory': true},
    {'name': 'Yacine', 'lat': 36.7600, 'lng': 3.0900, 'bitmoji': '🎮', 'streak': 178, 'distance': '0.8 km', 'hasStory': false},
    {'name': 'Amira', 'lat': 36.7380, 'lng': 3.0650, 'bitmoji': '🌸', 'streak': 95, 'distance': '1.7 km', 'hasStory': true},
    {'name': 'Rami', 'lat': 36.7450, 'lng': 3.0350, 'bitmoji': '🎸', 'streak': 64, 'distance': '2.3 km', 'hasStory': false},
  ];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onFriendAvatarTap(int index) {
    final friend = _friends[index];
    setState(() => _selectedFriendIndex = index);
    _mapController.move(LatLng(friend['lat'], friend['lng']), 15.0);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _selectedFriendIndex = -1);
    });
  }

  void _showFriendPreview(Map<String, dynamic> friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _FriendBottomSheet(friend: friend),
    );
  }

  List<Marker> _buildFriendMarkers() {
    return _friends.asMap().entries.map((entry) {
      final index = entry.key;
      final friend = entry.value;
      final isSelected = index == _selectedFriendIndex;

      return Marker(
        width: 90,
        height: 90,
        point: LatLng(friend['lat'], friend['lng']),
        child: GestureDetector(
          onTap: () => _showFriendPreview(friend),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: isSelected ? (Matrix4.identity()..scale(1.15)) : Matrix4.identity(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    border: Border.all(color: AppColors.primary, width: isSelected ? 3 : 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.background,
                    child: Text(friend['bitmoji'] as String, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    friend['name'] as String,
                    style: AppTextStyles.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
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
      width: 40,
      height: 40,
      point: const LatLng(36.7538, 3.0588),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40 * _pulseAnimation.value,
                height: 40 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.2 * (1.4 - _pulseAnimation.value)),
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.white, width: 3),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10)],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(36.7538, 3.0588),
            initialZoom: 12.0,
            maxZoom: 18.0,
            minZoom: 3.0,
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.setrise',
              tileBuilder: (context, tileWidget, tile) => ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2, 0.2, 0.2, 0, 0,
                  0.2, 0.2, 0.2, 0, 0,
                  0.2, 0.2, 0.2, 0, 0,
                  0.0, 0.0, 0.0, 0.8, 0,
                ]),
                child: tileWidget,
              ),
            ),
            if (!_ghostMode) MarkerLayer(markers: [_buildUserMarker()]),
            if (_showFriends && !_ghostMode)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
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
                        color: AppColors.primary,
                        border: Border.all(color: AppColors.white, width: 2),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12)],
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_ghostMode)
              Positioned.fill(
                child: Container(
                  color: AppColors.background.withOpacity(0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_off, color: AppColors.grey2, size: 48),
                        const SizedBox(height: 16),
                        Text('Ghost Mode is ON', style: AppTextStyles.h5.copyWith(color: AppColors.white)),
                        const SizedBox(height: 8),
                        Text('Your location is hidden', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search_rounded, color: AppColors.grey2, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search places or friends',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
                            border: InputBorder.none,
                          ),
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildToggleChip(label: 'Ghost Mode', icon: Icons.visibility_off, isActive: _ghostMode, onTap: () => setState(() => _ghostMode = !_ghostMode)),
                    const SizedBox(width: 8),
                    _buildToggleChip(label: 'Friends', icon: Icons.people, isActive: _showFriends, onTap: () => setState(() => _showFriends = !_showFriends)),
                    const SizedBox(width: 8),
                    _buildToggleChip(label: 'Heatmap', icon: Icons.terrain, isActive: _showHeatmap, onTap: () => setState(() => _showHeatmap = !_showHeatmap)),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!_ghostMode)
          Positioned(
            right: 16,
            bottom: 130,
            child: Column(
              children: [
                _mapControlButton(icon: Icons.my_location, onTap: () => _mapController.move(const LatLng(36.7538, 3.0588), 14.0)),
                const SizedBox(height: 8),
                _mapControlButton(icon: Icons.add, onTap: () {
                  final z = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, (z + 1).clamp(3.0, 18.0));
                }),
                const SizedBox(height: 8),
                _mapControlButton(icon: Icons.remove, onTap: () {
                  final z = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, (z - 1).clamp(3.0, 18.0));
                }),
              ],
            ),
          ),
        if (!_ghostMode)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 24, bottom: 12, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.background.withOpacity(0.9), AppColors.background],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
                        const SizedBox(width: 8),
                        Text('${_friends.length} friends nearby', style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey2)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        final friend = _friends[index];
                        final isSelected = index == _selectedFriendIndex;
                        return GestureDetector(
                          onTap: () => _onFriendAvatarTap(index),
                          child: Container(
                            width: 68,
                            margin: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.grey3, width: isSelected ? 3 : 2),
                                    boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10)] : null,
                                  ),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppColors.background,
                                    child: Text(friend['bitmoji'] as String, style: const TextStyle(fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(friend['name'] as String, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
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

  Widget _buildToggleChip({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isActive ? AppColors.primary : AppColors.grey3, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.white : AppColors.grey2, size: 16),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: isActive ? AppColors.white : AppColors.grey2)),
          ],
        ),
      ),
    );
  }

  Widget _mapControlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Icon(icon, color: AppColors.white, size: 22),
      ),
    );
  }
}

class _FriendBottomSheet extends StatelessWidget {
  final Map<String, dynamic> friend;
  const _FriendBottomSheet({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey3, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: friend['hasStory'] ? AppColors.primary : Colors.transparent, width: 2),
                ),
                child: CircleAvatar(radius: 30, backgroundColor: AppColors.background, child: Text(friend['bitmoji'] as String, style: const TextStyle(fontSize: 34))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(friend['name'] as String, style: AppTextStyles.h4.copyWith(color: AppColors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: AppColors.grey2),
                        const SizedBox(width: 4),
                        Text('Last seen: now', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey2)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text('${friend['streak']}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.straighten, size: 16, color: AppColors.grey2),
                const SizedBox(width: 8),
                Text('${friend['distance']} away', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2)),
                const Spacer(),
                Text('View on map', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(icon: Icons.chat_bubble_rounded, label: 'Chat', color: AppColors.primary, onTap: () => Navigator.pop(context)),
              _actionButton(icon: Icons.person_add_rounded, label: 'Friend', color: AppColors.primary, onTap: () => Navigator.pop(context)),
              _actionButton(icon: Icons.navigation_rounded, label: 'Navigate', color: AppColors.primary, onTap: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
        ],
      ),
    );
  }
}
