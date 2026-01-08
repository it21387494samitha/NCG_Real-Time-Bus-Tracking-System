// core/providers/map_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

class MapState {
  final LatLng? currentLocation;
  final Set<Marker> markers;
  final bool isLoading;
  final String? error;

  MapState({
    this.currentLocation,
    this.markers = const {},
    this.isLoading = false,
    this.error,
  });

  MapState copyWith({
    LatLng? currentLocation,
    Set<Marker>? markers,
    bool? isLoading,
    String? error,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  @override
  MapState build() {
    return MapState();
  }

  // In MapNotifier class, update getCurrentLocation:
Future<void> getCurrentLocation() async {
  state = state.copyWith(isLoading: true, error: null);
  
  try {
    final position = await LocationService.getCurrentLocation();
    
    if (position != null) {
      final latLng = LatLng(position.latitude, position.longitude);
      
      final marker = Marker(
        markerId: const MarkerId('current_location'),
        position: latLng,
        icon: await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/images/bus_marker.png', // Add a bus marker icon
        ),
      );

      state = state.copyWith(
        currentLocation: latLng,
        markers: {marker},
        isLoading: false,
      );
    } else {
      // If no location, use default (Colombo)
      final defaultLatLng = const LatLng(6.9271, 79.8612);
      final marker = Marker(
        markerId: const MarkerId('current_location'),
        position: defaultLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      state = state.copyWith(
        currentLocation: defaultLatLng,
        markers: {marker},
        isLoading: false,
      );
    }
  } catch (e) {
    debugPrint("Error getting location: $e");
    state = state.copyWith(
      isLoading: false,
      error: 'Error getting location: $e',
    );
  }
}

  void updateLocation(LatLng location) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: location,
      infoWindow: const InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    state = state.copyWith(
      currentLocation: location,
      markers: {marker},
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final mapProvider = NotifierProvider<MapNotifier, MapState>(
  MapNotifier.new,
);