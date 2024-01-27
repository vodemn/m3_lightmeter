import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/analytics/api/analytics_api_interface.dart';

class LightmeterAnalytics {
  final ILightmeterAnalyticsApi _api;

  const LightmeterAnalytics({required ILightmeterAnalyticsApi api}) : _api = api;

  Future<void> logEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    if (kDebugMode) {
      log('<LightmeterAnalytics> logEvent: $eventName / $parameters');
      return;
    }

    return _api.logEvent(
      eventName,
      parameters: parameters,
    );
  }

  Future<void> logCrash(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
  }) async {
    if (kDebugMode) {
      return;
    }

    return _api.logCrash(
      exception,
      stack,
      reason: reason,
      information: information,
    );
  }
}
