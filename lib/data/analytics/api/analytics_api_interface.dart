import 'package:lightmeter/data/analytics/entity/analytics_event.dart';

abstract class ILightmeterAnalyticsApi {
  Future<void> logEvent({
    required LightmeterAnalyticsEvent event,
    Map<String, dynamic>? parameters,
  });
}
