// features/tracking/presentation/widgets/map_preview.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/providers/map_provider.dart';

class MapPreview extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final double height;

  const MapPreview({
    super.key,
    required this.onTap,
    this.height = 200,
  });

  @override
  ConsumerState<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends ConsumerState<MapPreview> {
  GoogleMapController? _mapController;

  @override
  void didUpdateWidget(covariant MapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update camera when location changes
    _updateCamera();
  }

  void _updateCamera() {
    final mapState = ref.read(mapProvider);
    if (_mapController != null && mapState.currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(mapState.currentLocation!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Google Map
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mapState.currentLocation ?? const LatLng(6.9271, 79.8612), // Default to Colombo if no location
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _updateCamera();
                },
                markers: mapState.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                mapToolbarEnabled: false,
                onCameraIdle: () {},
              ),
              
              // Dark overlay with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              
              // Center indicator
              Center(
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              
              // Tap overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tap to expand',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}