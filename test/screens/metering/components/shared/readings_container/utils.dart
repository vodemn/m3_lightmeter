import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';

extension WidgetTesterActions on WidgetTester {
  Future<void> openAnimatedPicker<T>() async {
    await tap(find.byType(T));
    await pumpAndSettle(Dimens.durationL);
  }
}

void expectReadingValueContainerText(String text) => _expectTextDescendantOf<ReadingValueContainer>(text);

void expectDialogPickerText<T>(String text) => _expectTextDescendantOf<DialogPicker<T>>(text);

void _expectTextDescendantOf<T>(String text) {
  expect(find.descendant(of: find.byType(T), matching: find.text(text)), findsOneWidget);
}

void expectRadioListTile<T>(String text, {bool isSelected = false}) {
  expect(
    find.descendant(of: find.byType(RadioListTile<T>), matching: find.text(text)),
    findsOneWidget,
  );
}
