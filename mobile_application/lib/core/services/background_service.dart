// core/services/background_service.dart
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'api_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final logger = Logger();
    try {
      if (task == 'locationTask') {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        );
        
        // Get stored credentials
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final busId = prefs.getString('bus_id');
        final driverId = prefs.getString('driver_id');
        
        if (token != null && busId != null && driverId != null) {
          final api = ApiService();
          await api.sendLocationUpdate(
            latitude: position.latitude,
            longitude: position.longitude,
            busId: busId,
            driverId: driverId,
            token: token,
          );
        }
        
        return Future.value(true);
      }
    } catch (e) {
      logger.e('Background task failed: $e');
    }
    return Future.value(true);
  });
}

class BackgroundService {
  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
    );
  }
  
  static void startBackgroundTracking() {
    Workmanager().registerPeriodicTask(
      'locationTracking',
      'locationTask',
      frequency: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  
  static void stopBackgroundTracking() {
    Workmanager().cancelByUniqueName('locationTracking');
  }
}