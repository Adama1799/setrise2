import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/post_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  @override void initState() { super.initState(); _tabCtrl = TabController(length: 3, vsync: this); }
  @override void dispose() { _tabCtrl.dispose(); super.dispose(); }

  static const _colors = [
    Color(0xFF1A0A2E), Color(0xFF0A1628), Color(0xFF1A0A0A),
    Color(0xFF0A1A0A), Color(0xFF1A1A0A), Color(0xFF2E0A1A),
    Color(0xFF0A2E2E), Color(0xFF2E1A0A), Color(0xFF001A2E),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(child: SafeArea(child: Column(children: [
            // Top bar
            Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(children: [
                Text('Profile', style: AppTextStyles.h4.copyWith(color: AppColors.white, fontWeight: FontWeight.w900)),
                const Spacer(),
                GestureDetector(onTap: () => _showSettings(context),
                  child: const Icon(Icons.settings_outlined, color: AppColors.white, size: 24)),
              ])),
            const SizedBox(height: 16),
            // Avatar + stats
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  Container(width: 86, height: 86,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2), color: AppColors.grey),
                    child: const Icon(Icons.person, color: AppColors.white, size: 48)),
                  Positioned(bottom: 0, right: 0, child: Container(width: 28, height: 28,
                    decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2)),
                    child: const Icon(Icons.add, color: AppColors.black, size: 16))),
                ]),
                const SizedBox(width: 20),
                Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _stat('47', 'Posts'),
                  _stat('1.2K', 'Followers'),
                  _stat('380', 'Following'),
                ])),
              ])),
            const SizedBox(height: 12),
            // Bio
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('You', style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                Text('@setrise_user', style: AppTextStyles.body2.copyWith(color: AppColors.grey2)),
                const SizedBox(height: 6),
                Text('Just dropped the new SetRise update 🔥 #setrise #tech',
                  style: AppTextStyles.body2.copyWith(color: AppColors.white, height: 1.4)),
              ])),
            const SizedBox(height: 14),
            // Action buttons
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(child: _outlineBtn('Edit Profile', () {})),
                const SizedBox(width: 8),
                Expanded(child: _outlineBtn('Share Profile', () {})),
                const SizedBox(width: 8),
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.grey2),
                    borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.person_add_outlined, color: AppColors.white, size: 18)),
              ])),
            const SizedBox(height: 12),
          ]))),
          SliverPersistentHeader(pinned: true, delegate: _TabDelegate(
            TabBar(controller: _tabCtrl,
              indicatorColor: AppColors.white, indicatorWeight: 2,
              labelColor: AppColors.white, unselectedLabelColor: AppColors.grey2,
              tabs: const [
                Tab(icon: Icon(Icons.grid_on, size: 22)),
                Tab(icon: Icon(Icons.play_circle_outline, size: 22)),
                Tab(icon: Icon(Icons.bookmark_border, size: 22)),
              ]))),
        ],
        body: TabBarView(controller: _tabCtrl, children: [
          _Grid(colors: _colors),
          _Grid(colors: _colors, showLive: true),
          _EmptyState(icon: Icons.bookmark_border, label: 'No saved posts yet'),
        ]),
      ),
    );
  }

  Widget _stat(String val, String label) => Column(children: [
    Text(val, style: AppTextStyles.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
    const SizedBox(height: 2),
    Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey2)),
  ]);

  Widget _outlineBtn(String label, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(height: 36,
      decoration: BoxDecoration(border: Border.all(color: AppColors.grey2), borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(label, style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.white, fontWeight: FontWeight.bold)))));

  void _showSettings(BuildContext context) {
    showModalBottomSheet(context: context,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          _settingItem(Icons.account_circle_outlined, 'Account Settings'),
          _settingItem(Icons.privacy_tip_outlined, 'Privacy'),
          _settingItem(Icons.notifications_outlined, 'Notifications'),
          _settingItem(Icons.help_outline, 'Help & Support'),
          Divider(color: AppColors.grey.withOpacity(0.4), height: 24),
          Row(children: [
            const Icon(Icons.logout, color: AppColors.neonRed, size: 22),
            const SizedBox(width: 14),
            Text('Log Out', style: AppTextStyles.body1.copyWith(color: AppColors.neonRed)),
          ]),
        ])));
  }

  Widget _settingItem(IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(children: [
      Icon(icon, color: AppColors.white, size: 22),
      const SizedBox(width: 14),
      Text(label, style: AppTextStyles.body1.copyWith(color: AppColors.white)),
      const Spacer(),
      const Icon(Icons.chevron_right, color: AppColors.grey2, size: 20),
    ]));
}

class _Grid extends StatelessWidget {
  final List<Color> colors;
  final bool showLive;
  const _Grid({required this.colors, this.showLive = false});
  @override
  Widget build(BuildContext context) => GridView.builder(
    padding: const EdgeInsets.all(1),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
    itemCount: colors.length,
    itemBuilder: (_, i) => Container(color: colors[i],
      child: Stack(children: [
        Center(child: Icon(Icons.play_arrow, color: AppColors.white.withOpacity(0.15), size: 32)),
        if (showLive && i % 2 == 0)
          Positioned(top: 6, left: 6, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(4)),
            child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)))),
        Positioned(bottom: 6, left: 6, child: Row(children: [
          const Icon(Icons.play_arrow, color: AppColors.white, size: 12),
          const SizedBox(width: 2),
          Text(Formatters.formatCount((i + 1) * 1200),
            style: const TextStyle(color: AppColors.white, fontSize: 10, fontFamily: 'HarmonyOS')),
        ])),
      ])));
}

class _EmptyState extends StatelessWidget {
  final IconData icon; final String label;
  const _EmptyState({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, color: AppColors.grey2, size: 48),
    const SizedBox(height: 12),
    Text(label, style: AppTextStyles.body1.copyWith(color: AppColors.grey2)),
  ]));
}

class _TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabDelegate(this.tabBar);
  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;
  @override Widget build(_, __, ___) => Container(color: AppColors.background, child: tabBar);
  @override bool shouldRebuild(_) => false;
}
