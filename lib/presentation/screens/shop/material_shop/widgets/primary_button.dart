// material_shop/widgets/primary_button.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = AppDimensions.buttonHeightLg,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final bgColor = isDisabled
        ? AppColors.ctaPrimaryDisabledBg
        : AppColors.ctaPrimaryBg;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        alignment: Alignment.center,
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                      AppColors.ctaPrimaryFg),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: AppDimensions.xs),
                  ],
                  Text(
                    widget.label,
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: AppColors.ctaPrimaryFg,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
