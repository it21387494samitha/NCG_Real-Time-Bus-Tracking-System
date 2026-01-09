// features/tracking/presentation/widgets/floating_go_action.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FloatingGoAction extends StatefulWidget {
  final bool isOnline;
  final VoidCallback onGoOnline;

  const FloatingGoAction({
    super.key,
    required this.isOnline,
    required this.onGoOnline,
  });

  @override
  State<FloatingGoAction> createState() => _FloatingGoActionState();
}

class _FloatingGoActionState extends State<FloatingGoAction> with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOnline || !_isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 110,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            SystemSound.play(SystemSoundType.click);
            widget.onGoOnline();
            setState(() => _isVisible = false);
          },
          child: Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 8),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Center(
                  child: Text(
                    'GO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}