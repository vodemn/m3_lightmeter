abstract class ILightmeterAnalyticsApi {
  Future<void> logEvent(
    String eventName, {
    Map<String, Object>? parameters,
  });

  Future<void> logCrash(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
  });

  Future<void> setCustomKey(String key, String value);
}
