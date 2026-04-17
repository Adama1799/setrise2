import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DateFilterSheet extends StatefulWidget {
  final int maxDistance;
  final int ageFrom;
  final int ageTo;
  final bool sortBySharedInterests;
  final bool incognitoMode;
  final Function(int, int, int, bool, bool) onApply;

  const DateFilterSheet({
    super.key,
    required this.maxDistance,
    required this.ageFrom,
    required this.ageTo,
    required this.sortBySharedInterests,
    required this.incognitoMode,
    required this.onApply,
  });

  @override
  State<DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<DateFilterSheet>
    with SingleTickerProviderStateMixin {
  // --- Filter state ---
  late int _maxDistance;
  late int _ageFrom;
  late int _ageTo;
  late bool _sortBySharedInterests;
  late bool _incognitoMode;
  late bool _showOnlineOnly;

  // --- Gender filter ---
  String _selectedGender = 'All';
  final List<String> _genderOptions = ['All', 'Women', 'Men', 'Non-binary'];

  // --- Animation ---
  late AnimationController _sheetController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // --- Distance presets ---
  final List<Map<String, dynamic>> _distancePresets = [
    {'label': '5 كم', 'value': 5, 'icon': Icons.near_me_rounded},
    {'label': '25 كم', 'value': 25, 'icon': Icons.location_city_rounded},
    {'label': '50 كم', 'value': 50, 'icon': Icons.directions_car_rounded},
    {'label': '100 كم', 'value': 100, 'icon': Icons.public_rounded},
    {'label': '200 كم', 'value': 200, 'icon': Icons.explore_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _maxDistance = widget.maxDistance;
    _ageFrom = widget.ageFrom;
    _ageTo = widget.ageTo;
    _sortBySharedInterests = widget.sortBySharedInterests;
    _incognitoMode = widget.incognitoMode;
    _showOnlineOnly = false;

    // Entry animation
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    ));

    _sheetController.forward();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  LOGIC
  // =========================================================================

  int get _activeFilterCount {
    int count = 0;
    if (_maxDistance != 100) count++;
    if (_ageFrom != 18 || _ageTo != 35) count++;
    if (_sortBySharedInterests) count++;
    if (_incognitoMode) count++;
    if (_showOnlineOnly) count++;
    if (_selectedGender != 'All') count++;
    return count;
  }

  bool get _isDefault =>
      _maxDistance == 100 &&
      _ageFrom == 18 &&
      _ageTo == 35 &&
      !_sortBySharedInterests &&
      !_incognitoMode &&
      !_showOnlineOnly &&
      _selectedGender == 'All';

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _maxDistance = 100;
      _ageFrom = 18;
      _ageTo = 35;
      _sortBySharedInterests = false;
      _incognitoMode = false;
      _showOnlineOnly = false;
      _selectedGender = 'All';
    });
  }

  void _apply() {
    HapticFeedback.mediumImpact();
    widget.onApply(
      _maxDistance,
      _ageFrom,
      _ageTo,
      _sortBySharedInterests,
      _incognitoMode,
    );
    Navigator.pop(context);
  }

  void _selectDistancePreset(int value) {
    HapticFeedback.selectionClick();
    setState(() => _maxDistance = value);
  }

  void _selectGender(String gender) {
    HapticFeedback.selectionClick();
    setState(() => _selectedGender = gender);
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              _buildDragHandle(),

              // Header with active filters count
              _buildHeader(),

              const Divider(color: AppColors.grey2, height: 1),

              // Scrollable filter options
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 20),

                    // --- Gender Filter ---
                    _buildGenderFilter(),
                    const SizedBox(height: 28),

                    // --- Distance Filter ---
                    _buildDistanceFilter(),
                    const SizedBox(height: 28),

                    // --- Age Range Filter ---
                    _buildAgeRangeFilter(),
                    const SizedBox(height: 28),

                    // --- Toggle Filters ---
                    _buildToggleFilters(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),

              // Apply button
              _buildApplyButton(bottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  DRAG HANDLE
  // ---------------------------------------------------------------------------

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.grey2.withOpacity(0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 16),
      child: Row(
        children: [
          // Title
          const Text(
            'الفلاتر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 10),

          // Active filters badge
          if (_activeFilterCount > 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.dating.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.dating.withOpacity(0.3)),
              ),
              child: Text(
                '$_activeFilterCount نشط',
                style: const TextStyle(
                  color: AppColors.dating,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

          const Spacer(),

          // Reset button
          AnimatedOpacity(
            opacity: _isDefault ? 0.3 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: TextButton.icon(
              onPressed: _isDefault ? null : _reset,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text(
                'إعادة تعيين',
                style: TextStyle(
                  color: AppColors.dating,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.dating,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  GENDER FILTER
  // ---------------------------------------------------------------------------

  Widget _buildGenderFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.wc_rounded,
          title: 'الجنس',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _genderOptions.map((gender) {
            final isSelected = _selectedGender == gender;
            return _buildGenderChip(gender, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenderChip(String gender, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.dating,
                    AppColors.dating.withOpacity(0.7),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.dating.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.dating.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          gender == 'All'
              ? 'الكل'
              : gender == 'Women'
                  ? 'نساء'
                  : gender == 'Men'
                      ? 'رجال'
                      : 'غير ثنائي',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.grey2,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  DISTANCE FILTER
  // ---------------------------------------------------------------------------

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.location_on_rounded,
          title: 'المسافة القصوى',
          value: '$_maxDistance كم',
        ),
        const SizedBox(height: 14),

        // Distance presets (chips)
        Row(
          children: _distancePresets.map((preset) {
            final value = preset['value'] as int;
            final isSelected = _maxDistance == value;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  onTap: () => _selectDistancePreset(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.dating
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.dating
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          preset['icon'] as IconData,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : AppColors.grey2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preset['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppColors.grey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 كم',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$_maxDistance كم',
              style: const TextStyle(
                color: AppColors.dating,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '200 كم',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape:
                const RoundSliderOverlayShape(overlayRadius: 20),
            activeTickMarkShape: const RoundSliderTickMarkShape(),
          ),
          child: Slider(
            value: _maxDistance.toDouble(),
            min: 1,
            max: 200,
            divisions: 199,
            activeColor: AppColors.dating,
            inactiveColor: AppColors.grey2,
            onChanged: (value) {
              setState(() => _maxDistance = value.toInt());
            },
            onChangeEnd: (_) => HapticFeedback.selectionClick(),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  AGE RANGE FILTER
  // ---------------------------------------------------------------------------

  Widget _buildAgeRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.cake_rounded,
          title: 'العمر',
          value: '$_ageFrom - $_ageTo سنة',
        ),
        const SizedBox(height: 16),

        // Age range display with glassmorphism card
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAgeBubble('من', _ageFrom),
              // Arrow / dash
              Container(
                width: 36,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.dating.withOpacity(0.5),
                      AppColors.dating,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              _buildAgeBubble('إلى', _ageTo),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // From slider
        Row(
          children: [
            Text(
              '18',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: _ageFrom.toDouble(),
                  min: 18,
                  max: 79,
                  divisions: 61,
                  activeColor: AppColors.dating,
                  inactiveColor: AppColors.grey2,
                  onChanged: (value) {
                    setState(() {
                      _ageFrom = value.toInt();
                      if (_ageFrom >= _ageTo) {
                        _ageTo = _ageFrom + 1;
                      }
                    });
                  },
                  onChangeEnd: (_) => HapticFeedback.selectionClick(),
                ),
              ),
            ),
            Text(
              '$_ageFrom',
              style: const TextStyle(
                color: AppColors.dating,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        // To slider
        Row(
          children: [
            Text(
              '19',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: _ageTo.toDouble(),
                  min: 19,
                  max: 80,
                  divisions: 61,
                  activeColor: AppColors.dating,
                  inactiveColor: AppColors.grey2,
                  onChanged: (value) {
                    setState(() {
                      _ageTo = value.toInt();
                      if (_ageTo <= _ageFrom) {
                        _ageFrom = _ageTo - 1;
                      }
                    });
                  },
                  onChangeEnd: (_) => HapticFeedback.selectionClick(),
                ),
              ),
            ),
            Text(
              '$_ageTo',
              style: const TextStyle(
                color: AppColors.dating,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeBubble(String label, int age) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey2,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.dating.withOpacity(0.15),
                AppColors.dating.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: AppColors.dating.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              '$age',
              style: const TextStyle(
                color: AppColors.dating,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  TOGGLE FILTERS
  // ---------------------------------------------------------------------------

  Widget _buildToggleFilters() {
    return Column(
      children: [
        // Sort by shared interests
        _buildModernSwitchTile(
          icon: Icons.interests_rounded,
          title: 'ترتيب حسب الاهتمامات المشتركة',
          subtitle: 'اعرض الأشخاص ذوي الاهتمامات المشتركة أولاً',
          value: _sortBySharedInterests,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            setState(() => _sortBySharedInterests = value);
          },
        ),

        const SizedBox(height: 12),

        // Incognito mode
        _buildModernSwitchTile(
          icon: Icons.visibility_off_rounded,
          title: 'وضع التخفي',
          subtitle: 'تصفح دون أن يراك الآخرون',
          value: _incognitoMode,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            setState(() => _incognitoMode = value);
          },
          iconColor: Colors.purple,
          activeColor: Colors.purple,
        ),

        const SizedBox(height: 12),

        // Show online only
        _buildModernSwitchTile(
          icon: Icons.wifi_tethering_rounded,
          title: 'المتصلون فقط',
          subtitle: 'اعرض الأشخاص المتصلين حالياً',
          value: _showOnlineOnly,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            setState(() => _showOnlineOnly = value);
          },
          iconColor: AppColors.neonGreen,
          activeColor: AppColors.neonGreen,
        ),
      ],
    );
  }

  Widget _buildModernSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
    Color? activeColor,
  }) {
    final effectiveIconColor = iconColor ?? AppColors.dating;
    final effectiveActiveColor = activeColor ?? AppColors.dating;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value
            ? effectiveActiveColor.withOpacity(0.08)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value
              ? effectiveActiveColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: value
                  ? effectiveActiveColor.withOpacity(0.15)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? effectiveActiveColor : AppColors.grey2,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.grey2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Custom switch
          _buildModernSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: effectiveActiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 52,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: value
              ? LinearGradient(
                  colors: [
                    activeColor,
                    activeColor.withOpacity(0.7),
                  ],
                )
              : null,
          color: value ? null : AppColors.grey2,
          boxShadow: value
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: value
                ? Icon(
                    Icons.check_rounded,
                    color: activeColor,
                    size: 16,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  APPLY BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildApplyButton(double bottomPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.95),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _apply,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.dating,
            foregroundColor: Colors.black,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'تطبيق الفلاتر',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              if (_activeFilterCount > 0) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_activeFilterCount',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HELPERS
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.dating, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (value != null) ...[
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.dating.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.dating,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
