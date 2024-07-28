import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../application_mock.dart';
import '../../../../../../function_mock.dart';
import '../utils.dart';

void main() {
  final functions = MockValueChanged<int>();

  group(
    'onChanged',
    () {
      testWidgets(
        'other',
        (tester) async {
          await tester.pumpApplication(functions.onChanged);
          await tester.openAnimatedPicker<AnimatedDialogPicker<int>>();
          expect(find.byType(DialogPicker<int>), findsOneWidget);
          await tester.tapListTile(1);
          await tester.tapSelectButton();
          verify(() => functions.onChanged(1)).called(1);
        },
      );

      testWidgets(
        'same',
        (tester) async {
          await tester.pumpApplication(functions.onChanged);
          await tester.openAnimatedPicker<AnimatedDialogPicker<int>>();
          expect(find.byType(DialogPicker<int>), findsOneWidget);
          await tester.tapListTile(0);
          await tester.tapSelectButton();
          verify(() => functions.onChanged(0)).called(1);
        },
      );
    },
  );
}

extension WidgetTesterActions on WidgetTester {
  Future<void> pumpApplication(ValueChanged<int> onChanged) async {
    await pumpWidget(
      WidgetTestApplicationMock(
        child: Row(
          children: [
            Expanded(
              child: AnimatedDialogPicker<int>(
                icon: Icons.iso_outlined,
                title: '',
                subtitle: '',
                selectedValue: 0,
                values: List.generate(10, (index) => index),
                itemTitleBuilder: (_, value) => Text(value.toString()),
                itemTrailingBuilder: (selected, value) => null,
                onChanged: onChanged,
                closedChild: ReadingValueContainer.singleValue(
                  value: ReadingValue(
                    label: '',
                    value: 0.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> tapListTile(int iso) async {
    expect(find.descendant(of: find.byType(RadioListTile<int>), matching: find.text('$iso')), findsOneWidget);
    await tap(find.descendant(of: find.byType(RadioListTile<int>), matching: find.text('$iso')));
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
