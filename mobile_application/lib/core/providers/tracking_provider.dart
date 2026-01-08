// core/providers/tracking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingState {
  final bool isOnline;
  final bool isTracking;
  final DateTime? trackingStartedAt;

  TrackingState({
    this.isOnline = false,
    this.isTracking = false,
    this.trackingStartedAt,
  });

  TrackingState copyWith({
    bool? isOnline,
    bool? isTracking,
    DateTime? trackingStartedAt,
  }) {
    return TrackingState(
      isOnline: isOnline ?? this.isOnline,
      isTracking: isTracking ?? this.isTracking,
      trackingStartedAt: trackingStartedAt ?? this.trackingStartedAt,
    );
  }
}

class TrackingNotifier extends Notifier<TrackingState> {
  @override
  TrackingState build() {
    return TrackingState();
  }

  void goOnline() {
    state = state.copyWith(
      isOnline: true,
      isTracking: true,
      trackingStartedAt: DateTime.now(),
    );
  }

  void goOffline() {
    state = state.copyWith(
      isOnline: false,
      isTracking: false,
      trackingStartedAt: null,
    );
  }

  void startTracking() {
    state = state.copyWith(isTracking: true);
  }

  void stopTracking() {
    state = state.copyWith(isTracking: false);
  }
}

final trackingProvider = NotifierProvider<TrackingNotifier, TrackingState>(
  () => TrackingNotifier(),
);