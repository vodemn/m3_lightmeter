import 'package:package_info_plus/package_info_plus.dart';

class PlatformUtils {
  const PlatformUtils();

  Future<String> get version async => (await PackageInfo.fromPlatform()).version;

  Future<({String version, String buildNumber})> get buildVersion async =>
      PackageInfo.fromPlatform().then((value) => (version: value.version, buildNumber: value.buildNumber));
}
