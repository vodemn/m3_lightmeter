import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expectations.dart';
import 'widget_tester_actions.dart';

class MeteringValuesExpectation {
  final String fastestExposurePair;
  final String slowestExposurePair;
  final double ev;

  const MeteringValuesExpectation(
    this.fastestExposurePair,
    this.slowestExposurePair,
    this.ev,
  );
}

/// Runs the picker test
///
/// 1. Takes photo and verifies `expectBefore` values
/// 2. Opens a picker and select the provided value
/// 3. Verifies `expectAfter`
/// 4. Takes photo and verifies `expectAfter` values
@isTest
void testMeteringPicker<P, V>(
  String description, {
  required MeteringValuesExpectation expectBefore,
  required String valueToSelect,
  required MeteringValuesExpectation expectAfter,
  bool? skip,
}) {
  testWidgets(
    description,
    (tester) async {
      await tester.pumpApplication();
      await tester.toggleIncidentMetering(expectBefore.ev);

      // Verify that reciprocity failure is applies for the film is not selected
      expectExposurePairsContainer(expectBefore.fastestExposurePair, expectBefore.slowestExposurePair);
      expectMeasureButton(expectBefore.ev);

      await tester.openAnimatedPicker<P>();
      await tester.tapDescendantTextOf<DialogPicker<V>>(valueToSelect);
      await tester.tapSelectButton();

      /// Verify that exposure pairs are the same, except that the reciprocity failure is applied
      expectExposurePairsContainer(expectAfter.fastestExposurePair, expectAfter.slowestExposurePair);
      expectMeasureButton(expectAfter.ev);

      /// Make sure, that the EV is not changed
      await tester.toggleIncidentMetering(expectBefore.ev);
      expectExposurePairsContainer(expectAfter.fastestExposurePair, expectAfter.slowestExposurePair);
      expectMeasureButton(expectAfter.ev);
    },
    skip: skip,
  );
}
