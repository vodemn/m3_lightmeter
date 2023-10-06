import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../application_mock.dart';

class _ValueChanged {
  void onChanged<T>(T value) {}
}

class _MockValueChanged extends Mock implements _ValueChanged {}

void main() {
  final functions = _MockValueChanged();

  group(
    'onChanged',
    () {
      testWidgets(
        'other',
        (tester) async {
          await tester.pumpApplication(functions.onChanged);
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapListTile(500);
          await tester.tapSelectButton();
          verify(() => functions.onChanged(const IsoValue(500, StopType.third))).called(1);
        },
      );

      testWidgets(
        'same',
        (tester) async {
          await tester.pumpApplication(functions.onChanged);
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapListTile(400);
          await tester.tapSelectButton();
          verifyNever(() => functions.onChanged(const IsoValue(400, StopType.full)));
        },
      );
    },
  );
}

extension WidgetTesterActions on WidgetTester {
  Future<void> pumpApplication(ValueChanged<IsoValue> onChanged) async {
    await pumpWidget(
      WidgetTestApplicationMock(
        child: Row(
          children: [
            Expanded(
              child: IsoValuePicker(
                selectedValue: const IsoValue(400, StopType.full),
                values: IsoValue.values,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> openAnimatedPicker<T>() async {
    await tap(find.byType(T));
    await pumpAndSettle(Dimens.durationL);
  }

  Future<void> tapListTile(int iso) async {
    expect(find.descendant(of: find.byType(RadioListTile<IsoValue>), matching: find.text('$iso')), findsOneWidget);
    await tap(find.descendant(of: find.byType(RadioListTile<IsoValue>), matching: find.text('$iso')));
  }

  Future<void> tapSelectButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == S.current.select,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle();
  }
}
