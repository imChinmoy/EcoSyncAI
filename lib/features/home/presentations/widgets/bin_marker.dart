import 'package:ecosyncai/core/themes/app_color.dart';
import 'package:flutter/material.dart';

class BinMarker extends StatefulWidget {
  final String status;
  final VoidCallback onTap;
  final String binId;

  const BinMarker({
    super.key,
    required this.status,
    required this.onTap,
    required this.binId,
  });

  @override
  State<BinMarker> createState() => _BinMarkerState();
}

class _BinMarkerState extends State<BinMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  Color get _color {
    switch (widget.status.toLowerCase()) {
      case 'full':
        return AppColors.statusFull;
      case 'filling':
        return AppColors.statusFilling;
      default:
        return AppColors.statusEmpty;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.status.toLowerCase() == 'full') {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      )..repeat(reverse: true);
      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    } else {
      _controller = AnimationController(vsync: this);
      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: _color.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white, size: 14),
          ),
        ),
      ),
    );
  }
}
