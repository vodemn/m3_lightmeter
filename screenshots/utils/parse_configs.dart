import 'dart:convert';
import 'dart:io';

import '../models/screenshot_config.dart';

Map<String, ScreenshotConfig> parseScreenshotConfigs([String locale = 'en']) {
  final configPath = 'screenshots/assets/content/screenshot_titles_$locale.json';
  final data = jsonDecode(File(configPath).readAsStringSync()) as Map<String, dynamic>;
  final entries = (data['screenshots'] as List).map((value) {
    final config = ScreenshotConfig.fromJson(value as Map<String, dynamic>);
    return MapEntry(config.screenshotName, config);
  });
  return Map.fromEntries(entries);
}
