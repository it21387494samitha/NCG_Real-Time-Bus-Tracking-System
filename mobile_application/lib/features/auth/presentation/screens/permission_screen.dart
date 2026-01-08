// features/auth/presentation/screens/permission_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasPermission = await LocationService.hasPermission();
    if (hasPermission) {
      _navigateToHome();
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final status = await LocationService.requestPermissions();
      
      if (status == LocationPermissionStatus.granted) {
        _navigateToHome();
      } else if (status == LocationPermissionStatus.deniedForever) {
        setState(() {
          _errorMessage = 'Location permission permanently denied. Please enable it in app settings.';
        });
      } else if (status == LocationPermissionStatus.servicesDisabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable location services on your device.';
        });
      } else {
        setState(() {
          _errorMessage = 'Location permission denied. Please allow location access.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error requesting permission: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _openSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                Icons.location_on,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Location Permission Required',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                'Bus Tracker needs access to your location to:',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Features list
              _FeatureItem(
                icon: Icons.map,
                text: 'Show your current location on the map',
              ),
              _FeatureItem(
                icon: Icons.directions_bus,
                text: 'Track bus movements in real-time',
              ),
              _FeatureItem(
                icon: Icons.notifications,
                text: 'Send arrival notifications',
              ),
              
              const SizedBox(height: 32),
              
              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Buttons
              if (_errorMessage?.contains('settings') == true)
                ElevatedButton.icon(
                  onPressed: _openSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Settings'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _requestPermission,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.location_on),
                  label: Text(_isLoading ? 'Checking...' : 'Allow Location Access'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: _navigateToHome,
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}