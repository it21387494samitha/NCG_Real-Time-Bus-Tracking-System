// features/tracking/presentation/widgets/location_info_button.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInfoButton extends StatefulWidget {
  final LatLng? location;

  const LocationInfoButton({super.key, required this.location});

  @override
  State<LocationInfoButton> createState() => _LocationInfoButtonState();
}

class _LocationInfoButtonState extends State<LocationInfoButton> {
  final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
/*
    if (widget.location == null) return const SizedBox.shrink();

    return Positioned(
      top: 70,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Mini button
          GestureDetector(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                _isExpanded ? Icons.close : Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          // Expandable info card
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Current Location',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _LocationInfoRow(
                      label: 'Lat:',
                      value: widget.location!.latitude.toStringAsFixed(6),
                    ),
                    _LocationInfoRow(
                      label: 'Lng:',
                      value: widget.location!.longitude.toStringAsFixed(6),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
*/
  }
}

class _LocationInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _LocationInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'Monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}