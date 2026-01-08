// core/services/api_service.dart
import 'package:dio/dio.dart';
import 'offline_queue.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://your-backend-url.com/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  final OfflineQueueService _offlineQueue = OfflineQueueService();
  
  Future<void> sendLocationUpdate({
    required double latitude,
    required double longitude,
    required String busId,
    required String driverId,
    required String token,
  }) async {
    final locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String(),
      'bus_id': busId,
      'driver_id': driverId,
    };
    
    try {
      final response = await _dio.post(
        '/locations',
        data: locationData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      if (response.statusCode == 200) {
        print('Location sent successfully');
      }
    } catch (e) {
      // Store in offline queue if network fails
      await _offlineQueue.addLocation(
        latitude: latitude,
        longitude: longitude,
        busId: busId,
      );
      print('Location queued offline: $e');
    }
  }
  
  Future<void> syncOfflineLocations(String token) async {
    final pending = await _offlineQueue.getPendingLocations();
    
    for (final location in pending) {
      try {
        final response = await _dio.post(
          '/locations/batch',
          data: {
            'locations': pending.map((loc) => ({
              'latitude': loc['latitude'],
              'longitude': loc['longitude'],
              'timestamp': DateTime.fromMillisecondsSinceEpoch(loc['timestamp'] as int).toIso8601String(),
              'bus_id': loc['bus_id'],
            })).toList(),
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        
        if (response.statusCode == 200) {
          final ids = pending.map((loc) => loc['id'] as int).toList();
          await _offlineQueue.markAsSent(ids);
        }
      } catch (e) {
        print('Failed to sync offline locations: $e');
        break;
      }
    }
  }
}