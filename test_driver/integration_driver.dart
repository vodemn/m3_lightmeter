import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:uuid/v4.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [_]) async {
      final id = const UuidV4().generate();
      final path = 'e2e_diagnostics/screenshot_$id.png';
      final file = await File(path).create(recursive: true);
      file.writeAsBytesSync(bytes);

      final result = await Process.run(
        "curl",
        [
          "-F",
          'file=@${file.path}',
          "https://shot.withfra.me/new",
        ],
      );
      stdout.write(result.stdout);
      stderr.write(result.stderr);

      return true;
    },
  );
}
