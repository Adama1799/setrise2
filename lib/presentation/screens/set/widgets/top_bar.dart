import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  int _selectedContentTab = 0;
  int _selectedLevelTab = 0;

  final List<_ContentTab> _contentTabs = const [
    _ContentTab(label: 'Set', accent: Colors.white, pill: true),
    _ContentTab(label: 'Rize', accent: Colors.white, pill: true),
    _ContentTab(label: 'Shop', accent: Colors.orangeAccent, pill: false),
    _ContentTab(label: 'Date', accent: Colors.pinkAccent, pill: false),
    _ContentTab(label: 'Live', accent: Colors.redAccent, pill: false),
    _ContentTab(label: 'Music', accent: Colors.purpleAccent, pill: false),
  ];

  final List<String> _levels = const [
    'For You',
    'Stories',
    'Trending',
    'Watching',
  ];

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -250) {
          setState(() => _expanded = true);
        } else if (velocity > 250) {
          setState(() => _expanded = false);
        }
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              bottom: BorderSide(color: AppColors.border.withOpacity(0.55)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCompactHeader(),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  _buildQuickActions(),
                  const SizedBox(height: 12),
                  _buildChipRow(),
                  const SizedBox(height: 12),
                  _buildLevelsRow(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Row(
      children: [
        const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
        const SizedBox(width: 12),
        const Text(
          'SetRize',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        _buildCollapseHandle(),
      ],
    );
  }

  Widget _buildCollapseHandle() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _QuickAction(
          icon: Icons.wifi_rounded,
          label: 'Wi-Fi',
          onTap: () {},
        ),
        const SizedBox(width: 10),
        _QuickAction(
          icon: Icons.bluetooth_rounded,
          label: 'Bluetooth',
          onTap: () {},
        ),
        const SizedBox(width: 10),
        _QuickAction(
          icon: Icons.tune_rounded,
          label: 'Filter',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildChipRow() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _contentTabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final tab = _contentTabs[index];
          final isSelected = _selectedContentTab == index;

          return _Chip(
            label: tab.label,
            selected: isSelected,
            selectedColor: tab.pill ? Colors.white : tab.accent,
            textColor: tab.pill && isSelected ? Colors.black : Colors.white,
            onTap: () {
              setState(() => _selectedContentTab = index);
            },
          );
        },
      ),
    );
  }

  Widget _buildLevelsRow() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _levels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = _selectedLevelTab == index;
          return _Chip(
            label: _levels[index],
            selected: isSelected,
            selectedColor: AppColors.primary,
            textColor: Colors.white,
            onTap: () {
              setState(() => _selectedLevelTab = index);
            },
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final Color textColor;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? selectedColor : Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? selectedColor : Colors.white24,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentTab {
  final String label;
  final Color accent;
  final bool pill;

  const _ContentTab({
    required this.label,
    required this.accent,
    required this.pill,
  });
}
