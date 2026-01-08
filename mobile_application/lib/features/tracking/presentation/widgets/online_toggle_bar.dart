// features/tracking/presentation/widgets/online_toggle_bar.dart
import 'package:flutter/material.dart';

class OnlineToggleBar extends StatefulWidget {
  final bool isOnline;
  final VoidCallback onGoOnline;
  final VoidCallback onGoOffline;

  const OnlineToggleBar({
    super.key,
    required this.isOnline,
    required this.onGoOnline,
    required this.onGoOffline,
  });

  @override
  State<OnlineToggleBar> createState() => _OnlineToggleBarState();
}

class _OnlineToggleBarState extends State<OnlineToggleBar> {
  bool _isExpanded = false;
  final double _minHeight = 80; // Increased from 70
  final double _maxHeight = 160; // Increased from 140

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isExpanded ? _maxHeight : _minHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24), // More rounded
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle - made larger and more prominent
          GestureDetector(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            onVerticalDragUpdate: (details) {
              // Also allow dragging
              setState(() {
                _isExpanded = details.delta.dy < 0; // Drag up expands
              });
            },
            child: Container(
              height: 24,
              width: double.infinity,
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isOnline ? 'You\'re Online' : 'You\'re Offline',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isOnline 
                                ? 'Tracking your location in real-time'
                                : 'Tap GO to start tracking',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      _StatusIndicator(isOnline: widget.isOnline),
                    ],
                  ),

                  // Expanded Content - Shows when pulled up
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                          ),
                          const SizedBox(height: 20),
                          if (widget.isOnline)
                            _GoOfflineButton(onPressed: widget.onGoOffline)
                          else
                            _GoOnlineButton(onPressed: widget.onGoOnline),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final bool isOnline;

  const _StatusIndicator({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isOnline 
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? Colors.green : Colors.red,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isOnline ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
              color: isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoOnlineButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoOnlineButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: Colors.green.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, size: 24),
            const SizedBox(width: 10),
            Text(
              'GO ONLINE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoOfflineButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoOfflineButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: Colors.red.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stop_rounded, size: 24),
            const SizedBox(width: 10),
            Text(
              'GO OFFLINE',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}