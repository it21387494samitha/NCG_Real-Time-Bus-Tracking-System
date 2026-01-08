// features/tracking/presentation/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/providers/map_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Get location when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final mapNotifier = ref.read(mapProvider.notifier);

    // Show error if any
    if (mapState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(mapState.error!);
        mapNotifier.clearError();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (mapState.currentLocation != null && _isMapReady) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(mapState.currentLocation!),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              mapNotifier.getCurrentLocation();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _isMapReady = true;
              
              // Move camera to current location when map is ready
              if (mapState.currentLocation != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(mapState.currentLocation!),
                );
              }
            },
            markers: mapState.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraIdle: () {
              // Optional: Do something when camera stops moving
            },
          ),
          
          // Loading indicator
          if (mapState.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          
          // Location info card
          if (mapState.currentLocation != null && !mapState.isLoading)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _LocationInfoCard(location: mapState.currentLocation!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mapState.currentLocation != null && _isMapReady) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(mapState.currentLocation!),
            );
          }
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (error.contains('permission'))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }

  Future<void> _openAppSettings() async {
    // Using permission_handler to open app settings
    // You can also use: await openAppSettings();
    // If you have permission_handler package
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _LocationInfoCard extends StatelessWidget {
  final LatLng location;

  const _LocationInfoCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Location',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latitude',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Text(
                        location.latitude.toStringAsFixed(6),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Longitude',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Text(
                        location.longitude.toStringAsFixed(6),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}