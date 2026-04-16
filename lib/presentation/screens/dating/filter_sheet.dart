// lib/presentation/screens/date/filter_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DateFilterSheet extends StatefulWidget {
  final int maxDistance;
  final int ageFrom;
  final int ageTo;
  final bool sortBySharedInterests;
  final bool incognitoMode;
  final Function(int maxDistance, int ageFrom, int ageTo, bool sortByShared, bool incognito) onApply;

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
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Discovery Settings',
            style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            'Maximum Distance: $_maxDistance km',
            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w500),
          ),
          Slider(
            value: _maxDistance.toDouble(),
            min: 1,
            max: 500,
            divisions: 50,
            label: '$_maxDistance km',
            activeColor: AppColors.dating,
            onChanged: (value) => setState(() => _maxDistance = value.toInt()),
          ),
          const SizedBox(height: 20),
          Text(
            'Age Range',
            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _AgeSelector(
                  label: 'From',
                  value: _ageFrom,
                  onChanged: (value) => setState(() => _ageFrom = value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AgeSelector(
                  label: 'To',
                  value: _ageTo,
                  min: _ageFrom,
                  onChanged: (value) => setState(() => _ageTo = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            value: _sortBySharedInterests,
            onChanged: (value) => setState(() => _sortBySharedInterests = value),
            title: const Text('Show people with shared interests first'),
            subtitle: const Text('Profiles with more common interests appear first'),
            activeColor: AppColors.dating,
          ),
          SwitchListTile(
            value: _incognitoMode,
            onChanged: (value) => setState(() => _incognitoMode = value),
            title: const Text('Incognito Mode'),
            subtitle: const Text('Your profile will be hidden from others'),
            activeColor: Colors.purple,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_maxDistance, _ageFrom, _ageTo, _sortBySharedInterests, _incognitoMode);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dating,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AgeSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final Function(int) onChanged;

  const _AgeSelector({
    required this.label,
    required this.value,
    this.min = 18,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: List.generate(
              60 - min + 1,
              (index) => DropdownMenuItem(
                value: min + index,
                child: Text('${min + index}'),
              ),
            ),
            onChanged: (val) => onChanged(val!),
          ),
        ),
      ],
    );
  }
}
