// features/tracking/presentation/widgets/floating_go_action.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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

class _FloatingGoActionState extends State<FloatingGoAction> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (widget.isOnline || !_isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 100,
      right: 20,
      child: GestureDetector(
        onTap: () {
          widget.onGoOnline();
          setState(() => _isVisible = false);
        },
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.onlineGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.onlineGreen.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 2),
                Text(
                  'GO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}