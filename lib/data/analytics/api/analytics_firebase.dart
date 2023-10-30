import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/analytics/api/analytics_api_interface.dart';
import 'package:lightmeter/data/analytics/entity/analytics_event.dart';

class LightmeterAnalyticsFirebase implements ILightmeterAnalyticsApi {
  const LightmeterAnalyticsFirebase();

  @override
  Future<void> logEvent({
    required LightmeterAnalyticsEvent event,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: event.name,
        parameters: parameters,
      );
    } on FirebaseException catch (e) {
      debugPrint('Firebase Analytics Exception: $e');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
