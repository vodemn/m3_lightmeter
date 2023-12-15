import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';

extension WidgetTesterFinder on WidgetTester {
  Future<void> takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, String name) async {
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await pumpAndSettle();
    }
    await binding.takeScreenshot(name);
    await pumpAndSettle();
  }

  Future<void> takePhoto() async {
    await tap(find.byType(MeteringMeasureButton));
    await pump(const Duration(seconds: 2)); // wait for circular progress indicator
    await pump(const Duration(seconds: 1)); // wait for circular progress indicator
    await pumpAndSettle();
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) =>
          widget is TextButton &&
          widget.child is Text &&
          (widget.child as Text?)?.data == S.current.cancel,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle();
  }

  Future<void> tapListTile(String title) async {
    final listTile = find.byWidgetPredicate(
      (widget) =>
          widget is ListTile && widget.title is Text && (widget.title as Text?)?.data == title,
    );
    expect(listTile, findsOneWidget);
    await tap(listTile);
    await pumpAndSettle();
  }

  Future<void> openSettings() async {
    final settingsButton = find.byTooltip(S.current.tooltipOpenSettings);
    expect(settingsButton, findsOneWidget);
    await tap(settingsButton);
    await pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  }
}
