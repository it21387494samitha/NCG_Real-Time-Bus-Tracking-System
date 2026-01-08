// features/tracking/presentation/widgets/floating_go_button.dart
import 'package:flutter/material.dart';

class FloatingGoButton extends StatefulWidget {
  final bool isOnline;
  final VoidCallback onPressed;

  const FloatingGoButton({
    super.key,
    required this.isOnline,
    required this.onPressed,
  });

  @override
  State<FloatingGoButton> createState() => _FloatingGoButtonState();
}

class _FloatingGoButtonState extends State<FloatingGoButton> {
  bool _isVisible = true;

  @override
  void didUpdateWidget(covariant FloatingGoButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Show button again when going offline
    if (oldWidget.isOnline && !widget.isOnline) {
      setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || widget.isOnline) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 110, // Positioned above the toggle bar
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget.onPressed();
            setState(() => _isVisible = false);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'GO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}