// features/tracking/presentation/screens/full_map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/providers/map_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../widgets/dynamic_island.dart';
import '../widgets/status_indicator.dart';
import '../widgets/map_controls.dart';
import '../widgets/bottom_online_panel.dart';
import '../widgets/floating_go_button.dart';

class FullMapScreen extends ConsumerStatefulWidget {
  final bool isOnline;
  final VoidCallback onGoOnline;
  final VoidCallback onGoOffline;

  const FullMapScreen({
    super.key,
    required this.isOnline,
    required this.onGoOnline,
    required this.onGoOffline,
  });

  @override
  ConsumerState<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends ConsumerState<FullMapScreen> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  double _currentZoom = 15;
  CameraPosition? _lastCameraPosition;
  bool _isDynamicIslandExpanded = false;
  
  final List<Map<String, dynamic>> _mockCustomers = [
    {
      'name': 'John Smith',
      'phone': '+94 77 123 4567',
      'seat': 'A12',
      'distance': 2.5,
      'eta': '15 min',
    },
    {
      'name': 'Sarah Johnson',
      'phone': '+94 76 987 6543',
      'seat': 'B05',
      'distance': 4.2,
      'eta': '25 min',
    },
    {
      'name': 'Robert Brown',
      'phone': '+94 71 456 7890',
      'seat': 'C18',
      'distance': 1.8,
      'eta': '10 min',
    },
  ];
  
  int _currentCustomerIndex = 0;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).getCurrentLocation();
    });
  }
  
  void _toggleDynamicIsland() {
    setState(() {
      _isDynamicIslandExpanded = !_isDynamicIslandExpanded;
    });
  }
  
  void _nextCustomer() {
    setState(() {
      _currentCustomerIndex = (_currentCustomerIndex + 1) % _mockCustomers.length;
    });
  }
  
  void _resetCompass() {
    if (_mapController != null && _lastCameraPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _lastCameraPosition!.target,
            zoom: _lastCameraPosition!.zoom,
            bearing: 0,
            tilt: 0,
          ),
        ),
      );
    }
  }

  void _goToMyLocation() {
    final mapState = ref.read(mapProvider);
    if (mapState.currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          mapState.currentLocation!,
          16,
        ),
      );
    }
  }

  void _zoomIn() {
    if (_mapController != null) {
      setState(() => _currentZoom += 1);
      _mapController!.animateCamera(CameraUpdate.zoomIn());
    }
  }

  void _zoomOut() {
    if (_mapController != null) {
      setState(() => _currentZoom -= 1);
      _mapController!.animateCamera(CameraUpdate.zoomOut());
    }
  }
  
  void _toggleTheme() {
    final themeNotifier = ref.read(themeProvider.notifier);
    themeNotifier.toggleTheme();
  }
  
  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    
    final customer = _mockCustomers[_currentCustomerIndex];
    
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: mapState.currentLocation ?? const LatLng(6.9271, 79.8612),
              zoom: _currentZoom,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _isMapReady = true;
              
              if (mapState.currentLocation != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    mapState.currentLocation!,
                    _currentZoom,
                  ),
                );
              }
            },
            onCameraMove: (position) {
              _lastCameraPosition = position;
              _currentZoom = position.zoom;
            },
            markers: mapState.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            mapToolbarEnabled: false,
          ),

          // Top Bar with Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: Container(
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
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          
          // Dynamic Island (Center Top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 0,
            right: 0,
            child: Align(
              child: DynamicIsland(
                isExpanded: _isDynamicIslandExpanded,
                onTap: _toggleDynamicIsland,
                distance: customer['distance'],
                customerName: customer['name'],
                phoneNumber: customer['phone'],
                seatNumber: customer['seat'],
                eta: customer['eta'],
              ),
            ),
          ),
          
          // Status Indicator with Info (Top Right)
          StatusIndicator(
            isOnline: widget.isOnline,
            currentLocation: mapState.currentLocation,
            onThemeToggle: _toggleTheme,
          ),
          
          // Map Controls
          if (_isMapReady)
            MapControls(
              onCompassTap: _resetCompass,
              onLocationTap: _goToMyLocation,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              currentZoom: _currentZoom,
            ),
          
          // Next Customer Button (if dynamic island is collapsed)
          if (!_isDynamicIslandExpanded)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12 + 60, // Below dynamic island
              right: 16,
              child: GestureDetector(
                onTap: _nextCustomer,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swipe_right_alt,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Bottom Online/Offline Panel
          BottomOnlinePanel(
            isOnline: widget.isOnline,
            onGoOnline: widget.onGoOnline,
            onGoOffline: widget.onGoOffline,
            showInFullMap: true,
          ),
          
          // Floating Go Action (when offline)
          if (!widget.isOnline)
            Positioned(
              bottom: 100,
              right: 20,
              child: FloatingGoAction(
                isOnline: widget.isOnline,
                onGoOnline: widget.onGoOnline,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}