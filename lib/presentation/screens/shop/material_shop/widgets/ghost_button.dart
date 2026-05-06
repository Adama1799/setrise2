// material_shop/widgets/ghost_button.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

class GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? icon;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = AppDimensions.buttonHeightLg,
    this.icon,
  });

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.onPressed == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onPressed == null
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            },
      onTapCancel:
          widget.onPressed == null ? null : () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color:
              _pressed ? AppColors.backgroundSecondary : AppColors.ctaGhostBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.ctaGhostBorder),
        ),
        alignment: Alignment.center,
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.ctaGhostFg),
                ),
              )
            : Text(
                widget.label,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.ctaGhostFg,
                ),
              ),
      ),
    );
  }
}
