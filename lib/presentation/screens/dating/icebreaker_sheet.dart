// lib/presentation/screens/date/icebreaker_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class IcebreakerSheet extends StatefulWidget {
  final String matchName;
  final VoidCallback onSend;

  const IcebreakerSheet({
    super.key,
    required this.matchName,
    required this.onSend,
  });

  @override
  State<IcebreakerSheet> createState() => _IcebreakerSheetState();
}

class _IcebreakerSheetState extends State<IcebreakerSheet> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _icebreakers = [
    'What\'s the best movie you\'ve seen lately?',
    'If you could travel anywhere right now, where would you go?',
    'What\'s your favorite way to spend a weekend?',
    'Coffee or tea?',
    'What\'s the most spontaneous thing you\'ve ever done?',
    'Favorite food?',
  ];
  String? _selectedIcebreaker;

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
            'Break the ice with ${widget.matchName}',
            style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _icebreakers.map((question) {
              final isSelected = _selectedIcebreaker == question;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcebreaker = question;
                    _messageController.text = question;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.dating.withOpacity(0.2) : AppColors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? AppColors.dating : Colors.transparent),
                  ),
                  child: Text(question, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _messageController,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Or write your own message...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
              filled: true,
              fillColor: AppColors.grey.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSend();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dating,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SEND', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
