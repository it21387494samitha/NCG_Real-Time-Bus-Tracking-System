// features/tracking/presentation/widgets/map_controls.dart
import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onCompassTap;
  final VoidCallback onLocationTap;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapControls({
    super.key,
    required this.onCompassTap,
    required this.onLocationTap,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 120,
      child: Column(
        children: [
          // Compass Button
          _ControlButton(
            icon: Icons.explore_outlined,
            onPressed: onCompassTap,
            tooltip: 'Compass',
          ),
          const SizedBox(height: 12),
          
          // Location Button
          _ControlButton(
            icon: Icons.my_location,
            onPressed: onLocationTap,
            tooltip: 'My Location',
          ),
          const SizedBox(height: 12),
          
          // Zoom Controls
          Column(
            children: [
              _ControlButton(
                icon: Icons.add,
                onPressed: onZoomIn,
                tooltip: 'Zoom In',
                size: 40,
              ),
              Container(
                width: 40,
                height: 1,
                color: Colors.grey[300],
              ),
              _ControlButton(
                icon: Icons.remove,
                onPressed: onZoomOut,
                tooltip: 'Zoom Out',
                size: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}