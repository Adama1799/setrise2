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
  String? _selectedSuggestion;

  final List<String> _suggestedMessages = [
    'مرحباً! لاحظت أننا نشترك في نفس الاهتمامات 😊',
    'أهلاً! صورتك رائعة، من أين هذه؟',
    'مرحباً! ما رأيك في التعرف أكثر على بعضنا؟',
    'أهلاً بك! لاحظت أنك تحب السفر، ما هي وجهتك المفضلة؟',
    'مرحباً! 😊 ما الذي تبحث عنه هنا؟',
  ];

  void _onSuggestionTap(String suggestion) {
    setState(() {
      _selectedSuggestion = suggestion;
      _messageController.text = suggestion;
    });
  }

  void _onSend() {
    widget.onSend();
    Navigator.pop(context);
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
            child: Text(
              'أرسل رسالة إلى ${widget.matchName}',
              style: AppTextStyles.h4,
            ),
          ),
          
          const Divider(color: AppColors.grey3, height: 1),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Suggested Messages
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.neonYellow,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'رسائل مقترحة',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.grey1,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Suggestions List
                ..._suggestedMessages.map((suggestion) => GestureDetector(
                  onTap: () => _onSuggestionTap(suggestion),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedSuggestion == suggestion
                          ? AppColors.dating.withOpacity(0.1)
                          : AppColors.surface,
                      border: Border.all(
                        color: _selectedSuggestion == suggestion
                            ? AppColors.dating
                            : AppColors.grey3,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: _selectedSuggestion == suggestion
                            ? AppColors.dating
                            : Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )),
                
                const SizedBox(height: 24),
                
                // Custom Message
                Text(
                  'أو اكتب رسالتك الخاصة',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.grey1,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                TextField(
                  controller: _messageController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالتك هنا...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
          
          // Send Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _messageController.text.isNotEmpty ? _onSend : null,
                icon: const Icon(Icons.send_rounded),
                label: const Text('إرسال'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dating,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.grey3,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
