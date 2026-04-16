import 'package:flutter/material.dart';
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

class _DateFilterSheetState extends State<DateFilterSheet> {
  late int _maxDistance;
  late int _ageFrom;
  late int _ageTo;
  late bool _sortBySharedInterests;
  late bool _incognitoMode;

  @override
  void initState() {
    super.initState();
    _maxDistance = widget.maxDistance;
    _ageFrom = widget.ageFrom;
    _ageTo = widget.ageTo;
    _sortBySharedInterests = widget.sortBySharedInterests;
    _incognitoMode = widget.incognitoMode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الفلاتر',
                  style: AppTextStyles.h3,
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text(
                    'إعادة تعيين',
                    style: TextStyle(color: AppColors.dating),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(color: AppColors.grey3, height: 1),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Distance Filter
                _buildSectionTitle('المسافة القصوى'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('1 كم', style: AppTextStyles.bodySmall),
                    Text(
                      '$_maxDistance كم',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.dating,
                      ),
                    ),
                    const Text('200 كم', style: AppTextStyles.bodySmall),
                  ],
                ),
                Slider(
                  value: _maxDistance.toDouble(),
                  min: 1,
                  max: 200,
                  divisions: 199,
                  activeColor: AppColors.dating,
                  inactiveColor: AppColors.grey3,
                  onChanged: (value) {
                    setState(() {
                      _maxDistance = value.toInt();
                    });
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Age Range
                _buildSectionTitle('العمر'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('18', style: AppTextStyles.bodySmall),
                    Text(
                      '$_ageFrom - $_ageTo',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.dating,
                      ),
                    ),
                    const Text('80', style: AppTextStyles.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('من', style: AppTextStyles.bodySmall),
                          Slider(
                            value: _ageFrom.toDouble(),
                            min: 18,
                            max: 79,
                            divisions: 61,
                            activeColor: AppColors.dating,
                            inactiveColor: AppColors.grey3,
                            onChanged: (value) {
                              setState(() {
                                _ageFrom = value.toInt();
                                if (_ageFrom >= _ageTo) {
                                  _ageTo = _ageFrom + 1;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('إلى', style: AppTextStyles.bodySmall),
                          Slider(
                            value: _ageTo.toDouble(),
                            min: 19,
                            max: 80,
                            divisions: 61,
                            activeColor: AppColors.dating,
                            inactiveColor: AppColors.grey3,
                            onChanged: (value) {
                              setState(() {
                                _ageTo = value.toInt();
                                if (_ageTo <= _ageFrom) {
                                  _ageFrom = _ageTo - 1;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Sort by Shared Interests
                _buildSwitchTile(
                  'ترتيب حسب الاهتمامات المشتركة',
                  'اعرض الأشخاص ذوي الاهتمامات المشتركة أولاً',
                  _sortBySharedInterests,
                  (value) {
                    setState(() {
                      _sortBySharedInterests = value;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Incognito Mode
                _buildSwitchTile(
                  'وضع التخفي',
                  'تصفح دون أن يراك الآخرون',
                  _incognitoMode,
                  (value) {
                    setState(() {
                      _incognitoMode = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Apply Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    _maxDistance,
                    _ageFrom,
                    _ageTo,
                    _sortBySharedInterests,
                    _incognitoMode,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dating,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'تطبيق',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelLarge,
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelLarge),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.dating,
          activeTrackColor: AppColors.dating.withOpacity(0.3),
          inactiveTrackColor: AppColors.grey3,
        ),
      ],
    );
  }

  void _reset() {
    setState(() {
      _maxDistance = 100;
      _ageFrom = 18;
      _ageTo = 35;
      _sortBySharedInterests = false;
      _incognitoMode = false;
    });
  }
}
