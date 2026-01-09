// features/tracking/presentation/widgets/status_indicator.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class StatusIndicator extends StatefulWidget {
  final bool isOnline;
  final LatLng? currentLocation;
  final VoidCallback onThemeToggle;

  const StatusIndicator({
    super.key,
    required this.isOnline,
    this.currentLocation,
    required this.onThemeToggle,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  bool _showLocationInfo = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Status circle with info icon
          GestureDetector(
            onTap: () {
              setState(() => _showLocationInfo = !_showLocationInfo);
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  // Online/Offline dot
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Location info panel
          if (_showLocationInfo && widget.currentLocation != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildLocationInfo(context),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location Info',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showLocationInfo = false),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isOnline 
                  ? AppColors.onlineGreen.withOpacity(0.1)
                  : AppColors.offlineRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.isOnline ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    color: widget.isOnline ? AppColors.onlineGreen : AppColors.offlineRed,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Coordinates
          _CoordinateRow(
            label: 'Latitude',
            value: widget.currentLocation!.latitude.toStringAsFixed(6),
            context: context,
          ),
          _CoordinateRow(
            label: 'Longitude',
            value: widget.currentLocation!.longitude.toStringAsFixed(6),
            context: context,
          ),
          
          const SizedBox(height: 16),
          
          // Theme toggle button
          GestureDetector(
            onTap: widget.onThemeToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'Light Mode'
                        : 'Dark Mode',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
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

class _CoordinateRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _CoordinateRow({
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Monospace',
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}