import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';


void expectAnimatedPicker<T>(String title, String value) {
  final pickerFinder = find.byType(T);
  expect(find.descendant(of: pickerFinder, matching: find.text(title)), findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(value)), findsOneWidget);
}

/// Finds exactly one dialog picker of the provided value type
void expectDialogPicker<T>() {
  expect(find.byType(DialogPicker<T>), findsOneWidget);
}
