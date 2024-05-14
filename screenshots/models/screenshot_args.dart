import 'dart:convert';

class ScreenshotArgs {
  final String name;
  final String deviceName;
  final String platformFolder;
  final ({int r, int g, int b, int a}) backgroundColor;
  final bool isDark;

  const ScreenshotArgs({
    required this.name,
    required this.deviceName,
    required this.platformFolder,
    required this.backgroundColor,
    required this.isDark,
  });

  String toPathRaw() => 'screenshots/generated/raw/$platformFolder/$deviceName/$name.png';
  String toPath() => 'screenshots/generated/$platformFolder/$deviceName/$name.png';

  @override
  String toString() => jsonEncode(_toJson());

  factory ScreenshotArgs.fromString(String data) => ScreenshotArgs._fromJson(jsonDecode(data) as Map<String, dynamic>);

  factory ScreenshotArgs._fromJson(Map<String, dynamic> data) {
    final colorChannels = data['backgroundColor'] as List;
    return ScreenshotArgs(
      name: data['name'] as String,
      deviceName: data['deviceName'] as String,
      platformFolder: data['platformFolder'] as String,
      backgroundColor: (
        r: colorChannels[0] as int,
        g: colorChannels[1] as int,
        b: colorChannels[2] as int,
        a: colorChannels[3] as int,
      ),
      isDark: data['isDark'] as bool,
    );
  }

  Map<String, dynamic> _toJson() {
    return {
      "name": name,
      "deviceName": deviceName,
      "platformFolder": platformFolder,
      "backgroundColor": [
        backgroundColor.r,
        backgroundColor.g,
        backgroundColor.b,
        backgroundColor.a,
      ],
      "isDark": isDark,
    };
  }
}
