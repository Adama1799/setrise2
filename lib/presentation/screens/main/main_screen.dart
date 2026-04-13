import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../set/set_screen.dart';
import '../rize/rize_screen.dart';
import '../shop/shop_screen.dart';
import '../dating/dating_screen.dart';
import '../live/live_screen.dart';
import '../music/music_screen.dart';

import '../profile/profile_screen.dart';
import '../messages/messages_screen.dart';
import '../search/search_screen.dart';
import '../alerts/alerts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  // ───────────────────────── STATE CORE ─────────────────────────
  int _contentTab = 0;
  bool _panelOpen = false;

  final PageController _pageController = PageController();

  late final AnimationController _panelCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );

  late final Animation<double> _panelAnim =
      CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic);

  static const List<String> _tabs = [
    'Set', 'Rize', 'Shop', 'Date', 'Live', 'Music'
  ];

  bool _lock = false;

  // ───────────────────────── SAFE ENGINE ─────────────────────────
  void _safeRun(VoidCallback action) {
    if (_lock) return;

    _lock = true;
    action();

    Future.delayed(const Duration(milliseconds: 140), () {
      _lock = false;
    });
  }

  Duration _adaptiveDuration(double velocity) {
    if (velocity > 800) {
      return const Duration(milliseconds: 180);
    } else if (velocity < 200) {
      return const Duration(milliseconds: 320);
    }
    return const Duration(milliseconds: 240);
  }

  // ───────────────────────── PANEL CONTROL ─────────────────────────
  void _togglePanel() {
    _safeRun(() {
      HapticFeedback.lightImpact();

      if (_panelOpen) {
        _panelCtrl.reverse();
      } else {
        _panelCtrl.forward();
      }

      setState(() => _panelOpen = !_panelOpen);
    });
  }

  void _closePanel() {
    if (!_panelOpen) return;

    _safeRun(() {
      _panelCtrl.reverse();
      _panelOpen = false;
    });
  }

  // ───────────────────────── NAVIGATION ENGINE ─────────────────────────
  void _goToTab(int i) {
    _safeRun(() {
      setState(() => _contentTab = i);

      _pageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );

      if (_panelOpen) {
        _panelCtrl.reverse();
        _panelOpen = false;
      }
    });
  }

  // ───────────────────────── CONTENT ENGINE ─────────────────────────
  Widget _buildContent() {
    return PageView(
      controller: _pageController,
      physics: const ClampingScrollPhysics(),
      onPageChanged: (i) => setState(() => _contentTab = i),
      children: const [
        SetScreen(),
        RizeScreen(),
        ShopScreen(),
        DatingScreen(),
        LiveScreen(),
        MusicScreen(),
      ],
    );
  }

  // ───────────────────────── TOP BAR ─────────────────────────
  Widget _topBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Row(
          children: [

            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.menu_rounded,
                  color: Colors.white, size: 26),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: _togglePanel,
              child: Row(
                children: [
                  const Text(
                    'SetRize',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _panelOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 260),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: const Icon(Icons.search_rounded,
                  color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── PANEL UI ─────────────────────────
  Widget _panel() {
    return Positioned(
      top: -360 + (360 * _panelAnim.value),
      left: 0,
      right: 0,

      child: GestureDetector(
        onVerticalDragEnd: (d) {
          final v = d.primaryVelocity ?? 0;

          if (v > 600) {
            _closePanel();
          }
        },

        child: Container(
          color: Colors.black.withOpacity(0.93),

          child: SafeArea(
            bottom: false,
            child: Column(
              children: [

                const SizedBox(height: 44),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final active = i == _contentTab;

                      return GestureDetector(
                        onTap: () => _goToTab(i),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Column(
                            children: [

                              Text(
                                _tabs[i],
                                style: TextStyle(
                                  color: active
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: active
                                      ? FontWeight.w800
                                      : FontWeight.w400,
                                ),
                              ),

                              const SizedBox(height: 4),

                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: 2,
                                width: active ? 22 : 0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 180),

                Container(
                  width: 34,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────── BOTTOM NAV ─────────────────────────
  Widget _bottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.07)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              _nav(Icons.person, 0),
              _nav(Icons.chat, 1),
              _create(),
              _nav(Icons.notifications, 3),
              _nav(Icons.home, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nav(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _contentTab = 0);
      },
      child: Icon(icon, color: Colors.white70, size: 26),
    );
  }

  Widget _create() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 52,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text('+',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }

  // ───────────────────────── BUILD ─────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          _buildContent(),

          if (_panelAnim.value > 0)
            GestureDetector(
              onTap: _closePanel,
              child: Container(
                color: Colors.black.withOpacity(0.5 * _panelAnim.value),
              ),
            ),

          _panel(),

          _topBar(),
        ],
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }
}
