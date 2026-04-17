import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _IcebreakerSheetState extends State<IcebreakerSheet>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  int? _selectedSuggestionIndex;
  bool _isSending = false;

  // --- Suggested messages with categories ---
  final List<Map<String, dynamic>> _suggestedMessages = [
    {
      'message': 'مرحباً! لاحظت أننا نشترك في نفس الاهتمامات 😊',
      'category': 'اهتمامات مشتركة',
      'icon': Icons.interests_rounded,
      'color': AppColors.dating,
    },
    {
      'message': 'أهلاً! صورتك رائعة، من أين هذه؟ 📸',
      'category': 'مجاملة',
      'icon': Icons.camera_alt_rounded,
      'color': AppColors.neonYellow,
    },
    {
      'message': 'ما رأيك في التعرف أكثر على بعضنا؟',
      'category': 'دردشة',
      'icon': Icons.chat_bubble_rounded,
      'color': Colors.blue,
    },
    {
      'message': 'لاحظت أنك تحب السفر، ما هي وجهتك المفضلة؟ ✈️',
      'category': 'سفر',
      'icon': Icons.flight_rounded,
      'color': AppColors.neonGreen,
    },
    {
      'message': 'مرحباً! ما الذي تبحث عنه هنا؟ 😊',
      'category': 'عام',
      'icon': Icons.waving_hand_rounded,
      'color': Colors.orange,
    },
    {
      'message': 'يبدو أن لدينا ذوق موسيقي مشابه! 🎵',
      'category': 'موسيقى',
      'icon': Icons.music_note_rounded,
      'color': Colors.pink,
    },
  ];

  // --- Quick reactions ---
  final List<Map<String, dynamic>> _quickReactions = [
    {'emoji': '👋', 'label': 'مرحباً'},
    {'emoji': '😍', 'label': 'رائع'},
    {'emoji': '😂', 'label': 'مضحك'},
    {'emoji': '❤️', 'label': 'إعجاب'},
    {'emoji': '🔥', 'label': 'حار'},
    {'emoji': '☕', 'label': 'قهوة؟'},
  ];

  // --- Animation controllers ---
  late AnimationController _entryController;
  late AnimationController _sendController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const int _maxCharacters = 300;

  @override
  void initState() {
    super.initState();

    // Entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    // Send button animation
    _sendController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _entryController.forward();

    // Listen to text changes for live validation
    _messageController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _sendController.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // =========================================================================
  //  LOGIC
  // =========================================================================

  bool get _hasMessage => _messageController.text.trim().isNotEmpty;
  int get _charCount => _messageController.text.length;
  bool get _isOverLimit => _charCount > _maxCharacters;

  void _onSuggestionTap(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedSuggestionIndex = index;
      _messageController.text = _suggestedMessages[index]['message'] as String;
    });
    // Scroll to text field
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _onQuickReaction(int index) {
    HapticFeedback.selectionClick();
    final reaction = _quickReactions[index];
    setState(() {
      _selectedSuggestionIndex = null;
      _messageController.text = '${reaction['emoji']} ${reaction['label']}!';
    });
  }

  void _onSend() async {
    if (!_hasMessage || _isSending || _isOverLimit) return;

    HapticFeedback.mediumImpact();
    setState(() => _isSending = true);

    // Sending animation
    await _sendController.forward();

    if (mounted) {
      widget.onSend();
    }
  }

  void _clearMessage() {
    HapticFeedback.lightImpact();
    _messageController.clear();
    setState(() => _selectedSuggestionIndex = null);
  }

  // =========================================================================
  //  BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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

              // Match header with avatar
              _buildMatchHeader(),

              const Divider(color: AppColors.grey3, height: 1),

              // Quick reactions
              _buildQuickReactions(),

              // Scrollable content
              Flexible(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Suggested messages section
                    _buildSuggestionsSection(),

                    const SizedBox(height: 24),

                    // Custom message section
                    _buildCustomMessageSection(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Send button with character counter
              _buildSendArea(bottomPadding),
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
  //  MATCH HEADER
  // ---------------------------------------------------------------------------

  Widget _buildMatchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
      child: Row(
        children: [
          // Animated match avatar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.dating.withOpacity(0.3),
                    AppColors.neonRed.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: AppColors.dating.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.matchName.isNotEmpty
                      ? widget.matchName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.dating,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'أرسل رسالة إلى',
                      style: TextStyle(
                        color: AppColors.grey2,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.dating.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_rounded,
                              color: AppColors.dating, size: 10),
                          const SizedBox(width: 3),
                          const Text(
                            'Match جديد',
                            style: TextStyle(
                              color: AppColors.dating,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.matchName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.grey2,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  QUICK REACTIONS
  // ---------------------------------------------------------------------------

  Widget _buildQuickReactions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flash_on_rounded,
                color: AppColors.neonYellow,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'رد سريع',
                style: TextStyle(
                  color: AppColors.grey2,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReactions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final reaction = _quickReactions[index];
                return _buildQuickReactionChip(
                  emoji: reaction['emoji'] as String,
                  label: reaction['label'] as String,
                  onTap: () => _onQuickReaction(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReactionChip({
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SUGGESTIONS SECTION
  // ---------------------------------------------------------------------------

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.neonYellow,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'رسائل مقترحة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${_suggestedMessages.length}',
              style: TextStyle(
                color: AppColors.grey2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Suggestion cards with staggered animation
        ..._suggestedMessages.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isSelected = _selectedSuggestionIndex == index;
          return _buildSuggestionCard(
            message: data['message'] as String,
            category: data['category'] as String,
            icon: data['icon'] as IconData,
            color: data['color'] as Color,
            isSelected: isSelected,
            onTap: () => _onSuggestionTap(index),
            delay: index * 60,
          );
        }),
      ],
    );
  }

  Widget _buildSuggestionCard({
    required String message,
    required String category,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    int delay = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 400 + delay),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 16),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        color.withOpacity(0.12),
                        color.withOpacity(0.05),
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? color.withOpacity(0.4)
                    : Colors.white.withOpacity(0.06),
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : AppColors.grey2,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Message text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.15)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? color
                                : AppColors.grey2,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.grey2,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  CUSTOM MESSAGE SECTION
  // ---------------------------------------------------------------------------

  Widget _buildCustomMessageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const Icon(
              Icons.edit_rounded,
              color: AppColors.dating,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'أو اكتب رسالتك الخاصة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Text field with glassmorphism
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _focusNode.hasFocus
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppColors.dating.withOpacity(0.3)
                  : _isOverLimit
                      ? AppColors.neonRed.withOpacity(0.4)
                      : Colors.white.withOpacity(0.08),
              width: _focusNode.hasFocus || _isOverLimit ? 1.5 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.dating.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: 4,
                maxLength: _maxCharacters + 50,
                style: TextStyle(
                  color: _isOverLimit
                      ? AppColors.neonRed
                      : Colors.white.withOpacity(0.95),
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك هنا...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontWeight: FontWeight.w400,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(18, 16, 50, 8),
                  counterText: '',
                ),
              ),

              // Bottom bar: character count + clear button
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 14, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Character counter
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: _isOverLimit
                            ? AppColors.neonRed
                            : _charCount > _maxCharacters * 0.8
                                ? AppColors.neonYellow
                                : AppColors.grey2,
                        fontSize: 11,
                        fontWeight: _isOverLimit
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      child: Text(
                        _isOverLimit
                            ? '$_charCount / $_maxCharacters (تجاوز الحد!)'
                            : '$_charCount / $_maxCharacters',
                      ),
                    ),

                    // Clear button
                    if (_hasMessage)
                      GestureDetector(
                        onTap: _clearMessage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.neonRed.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppColors.neonRed,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //  SEND AREA
  // ---------------------------------------------------------------------------

  Widget _buildSendArea(double bottomPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12 + bottomPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.background.withOpacity(0.9),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Send button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: _buildSendButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final canSend = _hasMessage && !_isSending && !_isOverLimit;

    return GestureDetector(
      onTap: canSend ? _onSend : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: canSend
              ? const LinearGradient(
                  colors: [AppColors.dating, AppColors.neonRed],
                )
              : null,
          color: canSend ? null : AppColors.grey3.withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
          boxShadow: canSend
              ? [
                  BoxShadow(
                    color: AppColors.dating.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: _isSending
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_rounded,
                      color: canSend
                          ? Colors.white
                          : AppColors.grey2,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'إرسال الرسالة',
                      style: TextStyle(
                        color: canSend
                            ? Colors.white
                            : AppColors.grey2,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
