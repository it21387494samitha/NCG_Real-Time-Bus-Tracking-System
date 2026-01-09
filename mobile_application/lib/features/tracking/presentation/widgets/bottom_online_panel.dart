// features/tracking/presentation/widgets/bottom_online_panel.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BottomOnlinePanel extends StatefulWidget {
  final bool isOnline;
  final VoidCallback onGoOnline;
  final VoidCallback onGoOffline;
  final bool showInFullMap;

  const BottomOnlinePanel({
    super.key,
    required this.isOnline,
    required this.onGoOnline,
    required this.onGoOffline,
    this.showInFullMap = false,
  });

  @override
  State<BottomOnlinePanel> createState() => _BottomOnlinePanelState();
}

class _BottomOnlinePanelState extends State<BottomOnlinePanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: _isExpanded ? 140 : 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              onVerticalDragUpdate: (details) {
                setState(() => _isExpanded = details.delta.dy < 0);
              },
              child: Container(
                height: 32,
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                    // Status row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isOnline ? 'You\'re Online' : 'You\'re Offline',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isOnline 
                                  ? 'Live location tracking active'
                                  : 'Ready to start tracking',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: widget.isOnline 
                                ? AppColors.onlineGreen.withOpacity(0.15)
                                : AppColors.offlineRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.isOnline ? 'ONLINE' : 'OFFLINE',
                                style: TextStyle(
                                  color: widget.isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Expanded content
                    if (_isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: widget.isOnline
                            ? _buildOnlineContent(context)
                            : _buildOfflineContent(context),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineContent(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onGoOffline,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.offlineRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stop_circle, size: 22),
                const SizedBox(width: 10),
                Text(
                  'STOP & GO OFFLINE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineContent(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onGoOnline,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.onlineGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_fill, size: 22),
                const SizedBox(width: 10),
                Text(
                  'START & GO ONLINE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}