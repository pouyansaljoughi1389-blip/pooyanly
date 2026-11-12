import 'package:flutter/material.dart';

import '../theme/app_design_tokens.dart';

/// Shared, accessible action button used across onboarding and learning flows.
class PButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool isText;
  final bool isLoading;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double height;

  const PButton({
    super.key,
    required this.label,
    this.onPressed,
    this.outlined = false,
    this.isText = false,
    this.isLoading = false,
    this.icon,
    this.color,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final foreground = color == null
        ? theme.colorScheme.onPrimary
        : Colors.white;
    final child = _buildChild(
      isText ? effectiveColor : foreground,
      theme.colorScheme.onSurface,
    );

    if (isText) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: effectiveColor,
          minimumSize: Size(width ?? 44, height),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: child,
      );
    }

    final button = outlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: effectiveColor,
              minimumSize: Size(48, height),
              side: BorderSide(color: effectiveColor.withOpacity(.65)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDesignTokens.radiusMedium,
                ),
              ),
            ),
            child: child,
          )
        : FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: effectiveColor,
              foregroundColor: foreground,
              minimumSize: Size(48, height),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDesignTokens.radiusMedium,
                ),
              ),
            ),
            child: child,
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: button,
    );
  }

  Widget _buildChild(Color foreground, Color fallback) {
    if (isLoading) {
      return SizedBox(
        width: 21,
        height: 21,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }

    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Vazirmatn',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
    );

    if (icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: foreground),
        const SizedBox(width: 8),
        Flexible(child: text),
      ],
    );
  }
}
