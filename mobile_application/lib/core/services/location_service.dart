// core/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  
  // Request location permissions
  static Future<LocationPermissionStatus> requestPermissions() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.servicesDisabled;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }
    }

    // Check if we have background permission (for iOS 14+)
    if (permission == LocationPermission.whileInUse) {
      // Request always permission for background
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse
        ? LocationPermissionStatus.granted
        : LocationPermissionStatus.denied;
  }

  // Get current location with permission check
  static Future<Position?> getCurrentLocation() async {
    try {
      final permissionStatus = await requestPermissions();
      
      if (permissionStatus != LocationPermissionStatus.granted) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  // Stream location updates
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 30),
      ),
    ).handleError((error) {
      print("Location stream error: $error");
    });
  }

  // Check if we have permission
  static Future<bool> hasPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }

  // Open app settings for permission
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  servicesDisabled,
}