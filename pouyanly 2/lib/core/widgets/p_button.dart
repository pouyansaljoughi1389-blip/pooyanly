import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
    final effectiveColor = color ?? AppColors.primary;

    if (isText) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        child: Text(label,
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: effectiveColor,
            )),
      );
    }

    if (outlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveColor,
            side: BorderSide(color: effectiveColor, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          ),
          child: _buildChild(effectiveColor),
        ),
      );
    }

    // Gradient filled button
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [effectiveColor, Color.lerp(effectiveColor, Colors.white, 0.25)!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: effectiveColor.withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(child: _buildChild(Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(textColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textColor,
              )),
        ],
      );
    }

    return Text(label,
        style: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textColor,
        ));
  }
}
