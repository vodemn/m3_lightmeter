import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';

/// Expects exactly one picker of the specified type and verifies `title` or/and `value` if any of the values is not null.
void expectAnimatedPickerWith<T>({String? title, String? value}) {
  final pickerFinder = find.byType(T);
  expect(pickerFinder, findsOneWidget);
  if (title != null) {
    expect(
      find.descendant(of: pickerFinder, matching: find.text(title)),
      findsOneWidget,
    );
  }
  if (value != null) {
    expect(
      find.descendant(of: pickerFinder, matching: find.text(value)),
      findsOneWidget,
    );
  }
}

/// Finds exactly one dialog picker of the provided value type
void expectDialogPicker<T>() {
  expect(find.byType(DialogPicker<T>), findsOneWidget);
}

void expectMeasureButton(double ev) {
  find.descendant(
    of: find.byType(MeteringMeasureButton),
    matching: find.text('${ev.toStringAsFixed(1)}\n${S.current.ev}'),
  );
}

void expectExposurePairsContainer(String fastest, String slowest) {
  final pickerFinder = find.byType(ExtremeExposurePairsContainer);
  expect(pickerFinder, findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(S.current.fastestExposurePair)),
      findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(fastest)), findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(S.current.slowestExposurePair)),
      findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(slowest)), findsOneWidget);
}
