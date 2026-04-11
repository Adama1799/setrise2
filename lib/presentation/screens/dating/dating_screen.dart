import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DatingScreen extends StatefulWidget {
  const DatingScreen({super.key});
  @override
  State<DatingScreen> createState() => _DatingScreenState();
}

class _DatingScreenState extends State<DatingScreen>
    with SingleTickerProviderStateMixin {
  int _currentCard = 0;
  double _dragX = 0;
  final List<String> _matchedWith = [];

  final List<Map<String, dynamic>> _profiles = [
    {'name': 'Sara', 'age': 24, 'city': 'Algiers', 'bio': 'Coffee lover ☕ · Traveler ✈️ · Dog mom 🐕', 'interests': ['Travel', 'Photography', 'Music'], 'color': const Color(0xFF2A0A1A), 'isVerified': true, 'distance': '12 km', 'photos': 3},
    {'name': 'Nora', 'age': 22, 'city': 'Oran', 'bio': 'Artist 🎨 · Book lover 📚 · Real connection', 'interests': ['Art', 'Books', 'Cooking'], 'color': const Color(0xFF0A0A2A), 'isVerified': false, 'distance': '45 km', 'photos': 2},
    {'name': 'Lina', 'age': 26, 'city': 'Paris', 'bio': 'Software engineer 💻 · Gym addict 🏋️ · Foodie', 'interests': ['Tech', 'Fitness', 'Food'], 'color': const Color(0xFF2A1A0A), 'isVerified': true, 'distance': '102 km', 'photos': 4},
    {'name': 'Rania', 'age': 23, 'city': 'Cairo', 'bio': 'Architecture student 🏛️ · Night owl 🌙 · Anime', 'interests': ['Design', 'Anime', 'Gaming'], 'color': const Color(0xFF0A2A0A), 'isVerified': false, 'distance': '230 km', 'photos': 2},
    {'name': 'Hana', 'age': 25, 'city': 'Dubai', 'bio': 'Entrepreneur 💼 · Pilot in training ✈️ · Sunsets', 'interests': ['Business', 'Travel', 'Sports'], 'color': const Color(0xFF0A1A2A), 'isVerified': true, 'distance': '890 km', 'photos': 5},
  ];

  void _swipe(bool isLike) {
    if (_currentCard >= _profiles.length) return;
    if (isLike && _currentCard % 2 == 0) {
      _matchedWith.add(_profiles[_currentCard]['name']);
      _showMatch(_profiles[_currentCard]);
      return;
    }
    setState(() { _dragX = 0; _currentCard++; });
  }

  void _showMatch(Map p) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF1493), Color(0xFFFFB300)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(28)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('💛', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text("It's a Match!", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text('You and ${p['name']} liked each other!', style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Inter'), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () { Navigator.pop(context); setState(() { _dragX = 0; _currentCard++; }); },
              child: Container(width: double.infinity, height: 48,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: const Center(child: Text('Send Message 💬', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Inter'))))),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () { Navigator.pop(context); setState(() { _dragX = 0; _currentCard++; }); },
              child: const Text('Keep Swiping', style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Inter'))),
          ])),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Card: ratio ~900:1100 = 0.818
    final cardW = size.width - 32.0;
    final cardH = cardW * (1100 / 900);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(children: [
            const Icon(Icons.tune, color: AppColors.white, size: 24),
            const Spacer(),
            Column(children: [
              const Text('Date', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Inter')),
              if (_matchedWith.isNotEmpty)
                Text('${_matchedWith.length} matches 💛', style: const TextStyle(color: AppColors.dating, fontSize: 11, fontFamily: 'Inter')),
            ]),
            const Spacer(),
            const Icon(Icons.notifications_none, color: AppColors.white, size: 24),
          ])),

        // Cards stack
        Expanded(
          child: _currentCard >= _profiles.length
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text('No more profiles!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => setState(() { _currentCard = 0; }),
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.dating, borderRadius: BorderRadius.circular(14)),
                      child: const Text('Start Over', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Inter'))))
                ]))
              : Stack(alignment: Alignment.center, children: [
                  // Background card
                  if (_currentCard + 1 < _profiles.length)
                    Transform.scale(scale: 0.93,
                      child: _buildCard(_profiles[_currentCard + 1], cardW, cardH, false)),
                  // Front card - swipeable
                  GestureDetector(
                    onHorizontalDragUpdate: (d) => setState(() => _dragX += d.delta.dx),
                    onHorizontalDragEnd: (_) {
                      if (_dragX > 80) _swipe(true);
                      else if (_dragX < -80) _swipe(false);
                      else setState(() => _dragX = 0);
                    },
                    child: Transform.translate(
                      offset: Offset(_dragX, 0),
                      child: Transform.rotate(
                        angle: _dragX / 1200,
                        child: _buildCard(_profiles[_currentCard], cardW, cardH, true)))),
                ]),
        ),

        // Action buttons
        if (_currentCard < _profiles.length)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _btn(Icons.close, AppColors.neonRed, () => _swipe(false), 60),
              const SizedBox(width: 20),
              _btn(Icons.star, AppColors.dating, () {}, 44),
              const SizedBox(width: 20),
              _btn(Icons.favorite, const Color(0xFFFF1493), () => _swipe(true), 60),
            ])),
      ])),
    );
  }

  Widget _buildCard(Map p, double w, double h, bool isTop) {
    final isRight = isTop && _dragX > 40;
    final isLeft = isTop && _dragX < -40;
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        color: p['color'] as Color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]),
      child: Stack(children: [
        // Story-style photo dots at top
        Positioned(top: 12, left: 12, right: 12,
          child: Row(children: List.generate(p['photos'] as int, (i) =>
            Expanded(child: Container(
              height: 3, margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: i == 0 ? Colors.white : Colors.white38,
                borderRadius: BorderRadius.circular(2))))))),

        Center(child: Icon(Icons.person, color: Colors.white.withOpacity(0.06), size: 160)),

        // LIKE/NOPE stamps
        if (isRight) Positioned(top: 50, left: 20, child: Transform.rotate(angle: -0.3,
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFFF1493), width: 3), borderRadius: BorderRadius.circular(8)),
            child: const Text('LIKE 💛', style: TextStyle(color: Color(0xFFFF1493), fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Inter'))))),
        if (isLeft) Positioned(top: 50, right: 20, child: Transform.rotate(angle: 0.3,
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: AppColors.neonRed, width: 3), borderRadius: BorderRadius.circular(8)),
            child: const Text('NOPE ✕', style: TextStyle(color: AppColors.neonRed, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Inter'))))),

        // Bottom info
        Positioned(bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.92)]),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('${p['name']}  ${p['age']}',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                if (p['isVerified'] as bool) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.verified, color: AppColors.electricBlue, size: 18)],
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on, color: Colors.white60, size: 14),
                const SizedBox(width: 4),
                Text('${p['city']} · ${p['distance']}', style: const TextStyle(color: Colors.white60, fontSize: 13, fontFamily: 'Inter')),
              ]),
              const SizedBox(height: 8),
              Text(p['bio'], style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Inter')),
              const SizedBox(height: 10),
              Wrap(spacing: 6, children: (p['interests'] as List<String>).map((tag) =>
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.dating.withOpacity(0.6)), borderRadius: BorderRadius.circular(20)),
                  child: Text(tag, style: const TextStyle(color: AppColors.dating, fontSize: 11, fontFamily: 'Inter')))
              ).toList()),
              // Up arrow (super like)
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _swipe(true),
                  child: Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.dating.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: AppColors.dating, width: 1.5)),
                    child: const Icon(Icons.keyboard_arrow_up, color: AppColors.dating, size: 22)))),
            ])));
      ]));
  }

  Widget _btn(IconData icon, Color color, VoidCallback onTap, double size) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
          border: Border.all(color: color, width: 2),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12)]),
        child: Icon(icon, color: color, size: size * 0.45)));
  }
}
