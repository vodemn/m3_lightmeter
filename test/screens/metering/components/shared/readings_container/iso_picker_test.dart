import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../../../../../application_mock.dart';
import 'utils.dart';

void main() {
  Future<void> pumpApplication(
    WidgetTester tester, {
    List<IsoValue> values = IsoValue.values,
    IsoValue selectedValue = const IsoValue(100, StopType.full),
  }) async {
    assert(values.contains(selectedValue));
    await tester.pumpWidget(
      WidgetTestApplicationMock(
        child: Row(
          children: [
            Expanded(
              child: IsoValuePicker(
                selectedValue: selectedValue,
                values: values,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Check dialog icon and title consistency',
    (tester) async {
      await pumpApplication(tester);
      expectReadingValueContainerText(S.current.iso);
      await tester.openAnimatedPicker<IsoValuePicker>();
      expect(find.byIcon(Icons.iso), findsOneWidget);
      expectDialogPickerText<IsoValue>(S.current.iso);
      expectDialogPickerText<IsoValue>(S.current.filmSpeed);
    },
  );

  group(
    'Display selected value',
    () {
      testWidgets(
        'Any',
        (tester) async {
          await pumpApplication(tester);
          expectReadingValueContainerText('100');
          await tester.openAnimatedPicker<IsoValuePicker>();
          expectRadioListTile<IsoValue>('100', isSelected: true);
        },
      );
    },
  );
}
