// features/tracking/presentation/widgets/enhanced_map_controls.dart
import 'package:flutter/material.dart';

class MapControls extends StatefulWidget {
  final VoidCallback onCompassTap;
  final VoidCallback onLocationTap;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final double currentZoom;
  final bool isMapCentered;

  const MapControls({
    super.key,
    required this.onCompassTap,
    required this.onLocationTap,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.currentZoom,
    this.isMapCentered = false,
  });

  @override
  State<MapControls> createState() => _MapControlsState();
}

class _MapControlsState extends State<MapControls> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 140, // Positioned above bottom panel
      child: AnimatedScale(
        scale: widget.isMapCentered ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            // Zoom Level Indicator
            /*
            GestureDetector(
              onTap: () => setState(() => _showZoomLevel = !_showZoomLevel),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _showZoomLevel ? 80 : 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.zoom_in_map,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    if (_showZoomLevel) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${widget.currentZoom.toStringAsFixed(1)}x',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            */
            
            // Compass Button
            _MapControlButton(
              icon: Icons.explore,
              tooltip: 'Reset compass',
              onPressed: widget.onCompassTap,
              context: context,
            ),
            
            const SizedBox(height: 12),
            
            // Location Button
            _MapControlButton(
              icon: Icons.my_location,
              tooltip: 'Go to my location',
              onPressed: widget.onLocationTap,
              context: context,
            ),
            
            // const SizedBox(height: 12),
            
            // Zoom Controls Container
            /*
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _MapControlButton(
                    icon: Icons.add,
                    tooltip: 'Zoom in',
                    onPressed: widget.onZoomIn,
                    size: 40,
                    context: context,
                  ),
                  Container(
                    width: 40,
                    height: 1,
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  ),
                  _MapControlButton(
                    icon: Icons.remove,
                    tooltip: 'Zoom out',
                    onPressed: widget.onZoomOut,
                    size: 40,
                    context: context,
                  ),
                ],
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double size;
  final BuildContext context;

  const _MapControlButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.context,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            onTap: onPressed,
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}