import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';

Future<void> setTheme<T>(WidgetTester tester, Key scenarioWidgetKey, ThemeType themeType) async {
  final flow = find.descendant(
    of: find.byKey(scenarioWidgetKey),
    matching: find.byType(T),
  );
  final BuildContext context = tester.element(flow);
  UserPreferencesProvider.of(context).setThemeType(themeType);
  await tester.pumpAndSettle();
}
