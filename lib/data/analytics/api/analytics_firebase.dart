import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/analytics/api/analytics_api_interface.dart';

class LightmeterAnalyticsFirebase implements ILightmeterAnalyticsApi {
  const LightmeterAnalyticsFirebase();

  @override
  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: parameters,
      );
    } on FirebaseException catch (e) {
      debugPrint('Firebase Analytics Exception: $e');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> logCrash(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
  }) async {
    FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      reason: reason,
      information: information,
    );
  }

  @override
  Future<void> setCustomKey(String key, String value) async {
    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }
}
