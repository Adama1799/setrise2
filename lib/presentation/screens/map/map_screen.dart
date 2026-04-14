import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  bool _ghostMode = false;
  bool _showFriends = true;

  final List<Map<String, dynamic>> _friends = [
    {'name': 'Sara',  'lat': 36.7538, 'lng': 3.0588, 'bitmoji': '😎'},
    {'name': 'Ahmed', 'lat': 36.7520, 'lng': 3.0420, 'bitmoji': '🎧'},
    {'name': 'Lina',  'lat': 36.7210, 'lng': 3.1230, 'bitmoji': '📚'},
    {'name': 'Omar',  'lat': 36.7700, 'lng': 3.0100, 'bitmoji': '⚽'},
    {'name': 'Nour',  'lat': 36.7100, 'lng': 3.0800, 'bitmoji': '🎬'},
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  List<Marker> _buildFriendMarkers() {
    return _friends.map((friend) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(friend['lat'], friend['lng']),
        child: GestureDetector(
          onTap: () => _showFriendPreview(friend),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.electricBlue, width: 2),
                ),
                child: Text(friend['bitmoji'], style: const TextStyle(fontSize: 24)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(friend['name'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _showFriendPreview(Map<String, dynamic> friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 30, child: Text(friend['bitmoji'], style: const TextStyle(fontSize: 30))),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(friend['name'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('Last seen: now', style: TextStyle(color: Colors.white54)),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _previewAction(Icons.chat_bubble, 'Chat'),
              _previewAction(Icons.person_add, 'Friend'),
              _previewAction(Icons.location_on, 'Navigate'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _previewAction(IconData icon, String label) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[800], shape: BoxShape.circle), child: Icon(icon, color: Colors.white)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white70)),
    ]);
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
            ),
            if (_showFriends && !_ghostMode)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 15.0,
                  markers: _buildFriendMarkers(),
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.electricBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(child: Text(markers.length.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    );
                  },
                ),
              ),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildToggleChip(
                      label: 'Ghost Mode',
                      icon: Icons.visibility_off,
                      isActive: _ghostMode,
                      onTap: () => setState(() => _ghostMode = !_ghostMode),
                    ),
                    const SizedBox(width: 8),
                    _buildToggleChip(
                      label: 'Friends',
                      icon: Icons.people,
                      isActive: _showFriends,
                      onTap: () => setState(() => _showFriends = !_showFriends),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!_ghostMode)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _friends.length,
                itemBuilder: (context, index) {
                  final friend = _friends[index];
                  return GestureDetector(
                    onTap: () => _mapController.move(LatLng(friend['lat'], friend['lng']), 14.0),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Container(
                            width: 55, height: 55,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.electricBlue, width: 3)),
                            child: CircleAvatar(backgroundColor: Colors.grey[800], child: Text(friend['bitmoji'], style: const TextStyle(fontSize: 28))),
                          ),
                          const SizedBox(height: 4),
                          Text(friend['name'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildToggleChip({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.electricBlue.withOpacity(0.9) : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ]),
      ),
    );
  }
}
