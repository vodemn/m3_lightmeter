import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

import 'utils/android_camera_permission.dart';

Future<void> main() async {
  await grandCameraPermission();
  await integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        for (final String timelineName in data.keys) {
          final timeline = driver.Timeline.fromJson(data[timelineName] as Map<String, dynamic>);
          final summary = driver.TimelineSummary.summarize(timeline);

          // Write the entire timeline and summary to disk in a json format.
          // This file can be opened in the Chrome browser's tracing tools
          // found by navigating to chrome://tracing.
          await summary.writeTimelineToFile(
            timelineName,
            pretty: true,
          );
        }
      }
    },
  );
}
