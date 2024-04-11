import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: _defaultDevices +
          _defaultDevices
              .map(
                (d) => Device(
                  name: '${d.name} (Dark)',
                  size: d.size,
                  devicePixelRatio: d.devicePixelRatio,
                  safeArea: d.safeArea,
                  brightness: Brightness.dark,
                ),
              )
              .toList(),
    ),
  );
}

const _defaultDevices = <Device>[
  Device(
    name: 'iPhone 8',
    size: Size(375, 667),
    devicePixelRatio: 2.0,
  ),
  Device(
    name: 'iPhone 13 Pro',
    size: Size(390, 844),
    devicePixelRatio: 3.0,
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  ),
  Device(
    name: 'iPhone 15 Pro Max',
    size: Size(430, 932),
    devicePixelRatio: 3.0,
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  ),
];
