import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';

extension WidgetTesterTextButtonActions on WidgetTester {
  Future<void> tapSelectButton() => _tapTextButton(S.current.select);

  Future<void> tapCancelButton() => _tapTextButton(S.current.cancel);

  Future<void> tapSaveButton() => _tapTextButton(S.current.save);

  Future<void> _tapTextButton(String text) async {
    final button = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == text,
    );
    expect(button, findsOneWidget);
    await tap(button);
    await pumpAndSettle();
  }
}

extension WidgetTesterCommonActions on WidgetTester {
  Future<void> toggleIncidentMetering() async {
    await tap(find.byType(MeteringMeasureButton));
    await tap(find.byType(MeteringMeasureButton));
    await pumpAndSettle();
  }

  Future<void> openAnimatedPicker<T>() async {
    await tap(find.byType(T));
    await pumpAndSettle(Dimens.durationL);
  }
}
