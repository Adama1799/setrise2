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
  double _dragY = 0;
  final List<String> _matchedWith = [];

  final List<Map<String, dynamic>> _profiles = [
    // ... بيانات الملف الشخصي كما هي
    {'name':'Sara','age':24,'city':'Algiers','bio':'Coffee lover ☕ · Traveler ✈️ · Dog mom 🐕','interests':['Travel','Photography','Music'],'color':const Color(0xFF1A000A),'isVerified':true,'distance':'12 km'},
    {'name':'Nora','age':22,'city':'Oran','bio':'Artist 🎨 · Book lover 📚 · Looking for real connection','interests':['Art','Books','Cooking'],'color':const Color(0xFF0A001A),'isVerified':false,'distance':'45 km'},
    {'name':'Lina','age':26,'city':'Paris','bio':'Software engineer 💻 · Gym addict 🏋️ · Foodie 🍜','interests':['Tech','Fitness','Food'],'color':const Color(0xFF1A0A00),'isVerified':true,'distance':'102 km'},
    {'name':'Rania','age':23,'city':'Cairo','bio':'Architecture student 🏛️ · Night owl 🌙 · Anime fan 🎌','interests':['Design','Anime','Gaming'],'color':const Color(0xFF001A0A),'isVerified':false,'distance':'230 km'},
    {'name':'Hana','age':25,'city':'Dubai','bio':'Entrepreneur 💼 · Pilot in training ✈️ · Sunset chaser 🌅','interests':['Business','Travel','Sports'],'color':const Color(0xFF0A1A00),'isVerified':true,'distance':'890 km'},
  ];

  List<Map<String, dynamic>> get _remaining =>
      _profiles.skip(_currentCard).toList();

  void _swipe(bool isLike) {
    if (_currentCard >= _profiles.length) return;
    final profile = _profiles[_currentCard];
    if (isLike && _currentCard % 2 == 0) {
      setState(() => _matchedWith.add(profile['name'] as String));
      _showMatch(profile);
      return;
    }
    setState(() {
      _dragX = 0;
      _dragY = 0;
      _currentCard++;
    });
  }

  void _showMatch(Map profile) {
    // ... دالة showMatch كما هي
  }

  Widget _buildCard(Map profile,
      {bool withOverlay = false, double scale = 1.0, double offset = 0}) {
    final isRight = _dragX > 40;
    final isLeft = _dragX < -40;
    return Transform.scale(
      scale: scale,
      child: Transform.translate(
        offset: Offset(0, offset),
        child: Container(
          width: MediaQuery.of(context).size.width - 32,
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
            color: profile['color'] as Color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Stack(
            children: [
              Center(
                  child: Icon(Icons.person,
                      color: AppColors.white.withOpacity(0.08), size: 160)),
              if (withOverlay && isRight)
                Positioned(
                  top: 40,
                  left: 20,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.dating, width: 3),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('LIKE 💛',
                            style: TextStyle(
                                color: AppColors.dating,
                                fontSize: 22,
                                fontWeight: FontWeight.w900))),
                  ),
                ),
              if (withOverlay && isLeft)
                Positioned(
                  top: 40,
                  right: 20,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.neonRed, width: 3),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('NOPE ✕',
                            style: TextStyle(
                                color: AppColors.neonRed,
                                fontSize: 22,
                                fontWeight: FontWeight.w900))),
                  ),
                ),
              // معلومات الملف الشخصي في الأسفل (نفس الكود السابق)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9)
                        ]),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${profile['name']}  ${profile['age']}',
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          if (profile['isVerified'] as bool) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified,
                                color: AppColors.electricBlue, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppColors.grey2, size: 14),
                          const SizedBox(width: 4),
                          Text('${profile['city']} · ${profile['distance']}',
                              style: const TextStyle(
                                  color: AppColors.grey2, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(profile['bio'],
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 13)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        children: (profile['interests'] as List<String>)
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.dating
                                              .withOpacity(0.6)),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(tag,
                                      style: const TextStyle(
                                          color: AppColors.dating,
                                          fontSize: 11)),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => _swipe(true),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: AppColors.dating.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.dating, width: 1.5)),
                            child: const Icon(Icons.keyboard_arrow_up,
                                color: AppColors.dating, size: 22),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ حساب شدة اللون بناءً على مقدار السحب
    final double intensity = (_dragX.abs() / 150).clamp(0.0, 1.0);
    Color? bgColor;
    if (_dragX > 20) {
      bgColor = AppColors.neonGreen.withOpacity(intensity * 0.25);
    } else if (_dragX < -20) {
      bgColor = AppColors.neonRed.withOpacity(intensity * 0.25);
    } else {
      bgColor = Colors.transparent;
    }

    return SafeArea(
      child: Container(
        // ✅ الخلفية الكاملة التي تتغير لونها مع السحب
        color: bgColor,
        child: Column(
          children: [
            Expanded(
              child: _currentCard >= _profiles.length
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 60)),
                          const SizedBox(height: 16),
                          const Text('No more profiles!',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Check back later',
                              style: TextStyle(
                                  color: AppColors.grey2, fontSize: 14)),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () => setState(() => _currentCard = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                  color: AppColors.dating,
                                  borderRadius: BorderRadius.circular(14)),
                              child: const Text('Start Over',
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_currentCard + 1 < _profiles.length)
                          _buildCard(_profiles[_currentCard + 1],
                              scale: 0.92, offset: 12),
                        GestureDetector(
                          onHorizontalDragUpdate: (d) =>
                              setState(() => _dragX += d.delta.dx),
                          onHorizontalDragEnd: (_) {
                            if (_dragX > 80) {
                              _swipe(true);
                            } else if (_dragX < -80) {
                              _swipe(false);
                            } else {
                              setState(() => _dragX = 0);
                            }
                          },
                          child: Transform.translate(
                            offset: Offset(_dragX, _dragY * 0.2),
                            child: Transform.rotate(
                              angle: _dragX / 1000,
                              child: _buildCard(_profiles[_currentCard],
                                  withOverlay: true),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            if (_currentCard < _profiles.length)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _swipe(false),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.neonRed, width: 2),
                            color: AppColors.background),
                        child: const Icon(Icons.close,
                            color: AppColors.neonRed, size: 28),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _swipe(false),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.neonYellow, width: 1.5),
                            color: AppColors.background),
                        child: const Icon(Icons.star,
                            color: AppColors.neonYellow, size: 22),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _swipe(true),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.dating, width: 2),
                            color: AppColors.background),
                        child: const Icon(Icons.favorite,
                            color: AppColors.dating, size: 28),
                      ),
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
