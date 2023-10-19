import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../../../../../application_mock.dart';
import 'utils.dart';

void main() {
  Future<void> pumpApplication(
    WidgetTester tester, {
    List<NdValue> values = NdValue.values,
    NdValue selectedValue = const NdValue(0),
  }) async {
    assert(values.contains(selectedValue));
    await tester.pumpWidget(
      WidgetTestApplicationMock(
        child: Row(
          children: [
            Expanded(
              child: NdValuePicker(
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
      expectReadingValueContainerText(S.current.nd);
      await tester.openAnimatedPicker<NdValuePicker>();
      expect(find.byIcon(Icons.filter_b_and_w), findsOneWidget);
      expectDialogPickerText<NdValue>(S.current.nd);
      expectDialogPickerText<NdValue>(S.current.ndFilterFactor);
    },
  );

  group(
    'Display selected value',
    () {
      testWidgets(
        'None',
        (tester) async {
          await pumpApplication(tester);
          expectReadingValueContainerText(S.current.none);
          await tester.openAnimatedPicker<NdValuePicker>();
          expectRadioListTile<NdValue>(S.current.none, isSelected: true);
        },
      );

      testWidgets(
        'ND2',
        (tester) async {
          await pumpApplication(tester, selectedValue: const NdValue(2));
          expectReadingValueContainerText('2');
          await tester.openAnimatedPicker<NdValuePicker>();
          expectRadioListTile<NdValue>('2', isSelected: true);
        },
      );
    },
  );
}
