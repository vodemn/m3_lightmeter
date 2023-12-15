import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/analytics/api/analytics_api_interface.dart';
import 'package:lightmeter/data/analytics/entity/analytics_event.dart';

class LightmeterAnalytics {
  final ILightmeterAnalyticsApi _api;

  const LightmeterAnalytics({required ILightmeterAnalyticsApi api}) : _api = api;

  Future<void> logEvent(
    LightmeterAnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    if (kDebugMode) {
      log('<LightmeterAnalytics> logEvent: ${event.name} / $parameters');
      return;
    }

    return _api.logEvent(
      event: event,
      parameters: parameters,
    );
  }

  Future<void> logUnlockProFeatures(String listTileTitle) async {
    return logEvent(
      LightmeterAnalyticsEvent.unlockProFeatures,
      parameters: {"listTileTitle": listTileTitle},
    );
  }
}
