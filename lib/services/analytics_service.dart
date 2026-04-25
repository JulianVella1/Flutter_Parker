import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logAppOpened() async {
    await _analytics.logAppOpen();
  }

  static Future<void> logParkingCreated({
    required String parkingId,
    required String address,
  }) async {
    await _analytics.logEvent(
      name: 'parking_created',
      parameters: {'parking_id': parkingId, 'address': address},
    );
  }

  static Future<void> logParkingEnded({required String parkingId}) async {
    await _analytics.logEvent(
      name: 'parking_ended',
      parameters: {'parking_id': parkingId},
    );
  }

  static Future<void> logMapsOpened({required String parkingId}) async {
    await _analytics.logEvent(
      name: 'maps_opened',
      parameters: {'parking_id': parkingId},
    );
  }
}
