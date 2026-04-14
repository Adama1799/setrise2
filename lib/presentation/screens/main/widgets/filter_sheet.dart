// lib/presentation/screens/main/widgets/filter_sheet.dart

import 'package:flutter/material.dart';
import 'filter_state.dart';

class FilterSheet extends StatefulWidget {
  final VoidCallback onApply;
  const FilterSheet({super.key, required this.onApply});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String? _mood, _category, _sport, _region, _country;
  bool _showCountries = false;

  @override
  void initState() {
    super.initState();
    _mood     = FilterState.mood;
    _category = FilterState.category;
    _sport    = FilterState.sport;
    _region   = FilterState.region;
    _country  = FilterState.country;
    _showCountries = _region != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),

          _title('😊 Mood'),
          const SizedBox(height: 8),
          _chips(kMoods, _mood, (v) => setState(() => _mood = v)),
          const SizedBox(height: 16),

          _title('🎯 Category'),
          const SizedBox(height: 8),
          _chips(kCategories, _category, (v) => setState(() => _category = v)),
          const SizedBox(height: 16),

          _title('🏆 Sports'),
          const SizedBox(height: 8),
          _chips(kSports, _sport, (v) => setState(() => _sport = v)),
          const SizedBox(height: 16),

          _title('🌍 Region & Country'),
          const SizedBox(height: 8),
          _chips(kRegions.keys.toList(), _region, (v) {
            setState(() { _region = v; _country = null; _showCountries = true; });
          }),

          if (_showCountries && _region != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🗺️ $_region', style: const TextStyle(
                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _chips(kRegions[_region] ?? [], _country,
                        (v) => setState(() => _country = v)),
              ]),
            ),
          ],

          const SizedBox(height: 24),

          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () {
                setState(() {
                  _mood = _category = _sport = _region = _country = null;
                  _showCountries = false;
                });
                FilterState.reset();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Reset All',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              ),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () {
                FilterState.mood     = _mood;
                FilterState.category = _category;
                FilterState.sport    = _sport;
                FilterState.region   = _region;
                FilterState.country  = _country;
                widget.onApply();
                Navigator.pop(context);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('Apply',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _title(String t) => Text(t,
      style: const TextStyle(color: Colors.black, fontSize: 14,
          fontWeight: FontWeight.bold));

  Widget _chips(List<String> items, String? selected, Function(String) onTap) {
    return Wrap(
      spacing: 6, runSpacing: 6,
      children: items.map((item) {
        final isSel = selected == item;
        return GestureDetector(
          onTap: () => onTap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: isSel ? Colors.black : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isSel ? Colors.black : Colors.grey.shade300)),
            child: Text(item, style: TextStyle(
                color: isSel ? Colors.white : Colors.black,
                fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        );
      }).toList(),
    );
  }
}
