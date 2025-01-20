import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lightmeter/data/analytics/api/analytics_api_interface.dart';

class LightmeterAnalytics {
  final ILightmeterAnalyticsApi _api;

  const LightmeterAnalytics({required ILightmeterAnalyticsApi api}) : _api = api;

  void init() {
    FlutterError.onError = (details) {
      if (details.silent) return;
      logCrash(details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      logCrash(error, stack);
      return true;
    };
  }

  Future<void> logEvent(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    if (!kReleaseMode) {
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
    StackTrace? stackTrace, {
    dynamic reason,
    Iterable<Object> information = const [],
  }) async {
    log(exception.toString(), stackTrace: stackTrace);
    if (!kReleaseMode) {
      return;
    }

    return _api.logCrash(
      exception,
      stackTrace,
      reason: reason,
      information: information,
    );
  }

  Future<void> setCustomKey(String key, String value) async => _api.setCustomKey(key, value);
}
