import 'dart:convert';

class ScreenshotArgs {
  final String name;
  final String deviceName;
  final String platformFolder;
  final String backgroundColor;
  final bool isDark;

  static const _pathArgsDelimited = '_';

  ScreenshotArgs({
    required this.name,
    required String deviceName,
    required this.platformFolder,
    required this.backgroundColor,
    required this.isDark,
  }) : deviceName = deviceName.replaceAll(' ', _pathArgsDelimited).replaceAll(RegExp('[(|)]'), '').toLowerCase();

  ScreenshotArgs.fromRawName({
    required String name,
    required String deviceName,
    required this.platformFolder,
  })  : name = name.split(_pathArgsDelimited)[1],
        deviceName = deviceName.replaceAll(' ', _pathArgsDelimited).replaceAll(RegExp('[(|)]'), '').toLowerCase(),
        backgroundColor = name.split(_pathArgsDelimited)[2],
        isDark = name.contains('dark');

  static const _folderPrefix = 'screenshots/generated';
  String get nameWithTheme => '${isDark ? 'dark' : 'light'}$_pathArgsDelimited$name';

  String toPathRaw() =>
      '$_folderPrefix/raw/$platformFolder/$deviceName/$nameWithTheme$_pathArgsDelimited$backgroundColor.png';
  String toPath() => '$_folderPrefix/$platformFolder/$deviceName/$name.png';

  @override
  String toString() => jsonEncode(_toJson());

  factory ScreenshotArgs.fromString(String data) => ScreenshotArgs._fromJson(jsonDecode(data) as Map<String, dynamic>);

  factory ScreenshotArgs._fromJson(Map<String, dynamic> data) {
    return ScreenshotArgs(
      name: data['name'] as String,
      deviceName: data['deviceName'] as String,
      platformFolder: data['platformFolder'] as String,
      backgroundColor: data['backgroundColor'] as String,
      isDark: data['isDark'] as bool,
    );
  }

  Map<String, dynamic> _toJson() {
    return {
      "name": name,
      "deviceName": deviceName,
      "platformFolder": platformFolder,
      "backgroundColor": backgroundColor,
      "isDark": isDark,
    };
  }
}
