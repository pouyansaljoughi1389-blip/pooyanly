import 'dart:ui';
import 'package:flutter/material.dart';

/// Shared translucent surface used by POUYANLY's glass design system.
class LiquidGlass extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  const LiquidGlass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.onTap,
  });

  @override
  State<LiquidGlass> createState() => _LiquidGlassState();
}

class _LiquidGlassState extends State<LiquidGlass> {
  bool _pressed = false;
  Offset _drag = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = AnimatedScale(
      scale: _pressed ? .975 : 1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.elasticOut,
      child: Transform.translate(
        offset: _drag,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? [const Color(0xB83A2A68), const Color(0x8820183D), const Color(0x663B2A66)]
                      : [const Color(0xDFFFFFFF), const Color(0xA6E8E5FF), const Color(0x80FFFFFF)],
                ),
                border: Border.all(
                  color: dark ? Colors.white.withOpacity(.24) : Colors.white.withOpacity(.78),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7656D6).withOpacity(dark ? .22 : .14),
                    blurRadius: _pressed ? 12 : 26,
                    offset: Offset(0, _pressed ? 3 : 10),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(dark ? .07 : .55),
                    blurRadius: 2,
                    offset: const Offset(-1, -1),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.onTap == null) return surface;
    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (_) => setState(() => _pressed = true),
      onPanUpdate: (details) => setState(() {
        _drag = Offset(
          (_drag.dx + details.delta.dx * .22).clamp(-8.0, 8.0).toDouble(),
          (_drag.dy + details.delta.dy * .22).clamp(-8.0, 8.0).toDouble(),
        );
      }),
      onPanEnd: (_) => setState(() { _pressed = false; _drag = Offset.zero; }),
      onPanCancel: () => setState(() { _pressed = false; _drag = Offset.zero; }),
      child: surface,
    );
  }
}
class LiquidGlassNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const LiquidGlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.map_rounded, label: 'مسیر'),
    (icon: Icons.home_rounded, label: 'خانه'),
    (icon: Icons.menu_book_rounded, label: 'لغت'),
    (icon: Icons.emoji_events_rounded, label: 'جوایز'),
    (icon: Icons.person_rounded, label: 'من'),
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: LiquidGlass(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 58,
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: Alignment(
                    1 - (2 * selectedIndex / (_items.length - 1)),
                    0,
                  ),
                  duration: const Duration(milliseconds: 620),
                  curve: Curves.elasticOut,
                  child: FractionallySizedBox(
                    widthFactor: 1 / _items.length,
                    heightFactor: .92,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(.16),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: color.withOpacity(.20)),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(_items.length, (index) {
                    final item = _items[index];
                    final active = selectedIndex == index;
                    return Expanded(
                      child: _JellyNavItem(
                        icon: item.icon,
                        label: item.label,
                        active: active,
                        color: color,
                        onTap: () => onTap(index),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JellyNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _JellyNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  State<_JellyNavItem> createState() => _JellyNavItemState();
}

class _JellyNavItemState extends State<_JellyNavItem> {
  bool _pressed = false;
  Offset _drag = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final inactive = Theme.of(context).colorScheme.onSurfaceVariant;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() { _pressed = false; _drag = Offset.zero; }),
      onTapUp: (_) => setState(() { _pressed = false; _drag = Offset.zero; }),
      onPanStart: (_) => setState(() => _pressed = true),
      onPanUpdate: (details) => setState(() {
        _drag = Offset(
          (_drag.dx + details.delta.dx * .22).clamp(-8.0, 8.0),
          (_drag.dy + details.delta.dy * .22).clamp(-8.0, 8.0),
        );
      }),
      onPanEnd: (_) => setState(() { _pressed = false; _drag = Offset.zero; }),
      onPanCancel: () => setState(() { _pressed = false; _drag = Offset.zero; }),
      child: AnimatedScale(
        scale: _pressed ? .82 : (widget.active ? 1.04 : 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        child: Transform.translate(
          offset: _drag,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 22, color: widget.active ? widget.color : inactive),
            const SizedBox(height: 2),
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 10,
                fontWeight: widget.active ? FontWeight.w900 : FontWeight.w500,
                color: widget.active ? widget.color : inactive,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
