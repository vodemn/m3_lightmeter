import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/components/exposure_pairs_list_item/widget_item_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/utils/widget_tester_actions.dart';
import 'mocks/paid_features_mock.dart';

const mockPhotoFastestAperture = ApertureValue(1, StopType.full);
const mockPhotoSlowestAperture = ApertureValue(45, StopType.full);
const mockPhotoFastestShutterSpeed = ShutterSpeedValue(320, true, StopType.third);
const mockPhotoSlowestShutterSpeed = ShutterSpeedValue(6, false, StopType.third);
const mockPhotoFastestExposurePair = ExposurePair(mockPhotoFastestAperture, mockPhotoFastestShutterSpeed);
const mockPhotoSlowestExposurePair = ExposurePair(mockPhotoSlowestAperture, mockPhotoSlowestShutterSpeed);

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

@isTestGroup
void testMeteringScreenPickers(String description) {
  group(
    description,
    () {
      setUp(() {
        SharedPreferences.setMockInitialValues({
          /// Metering values
          UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
          UserPreferencesService.meteringScreenLayoutKey: json.encode(
            {
              MeteringScreenLayoutFeature.equipmentProfiles: true,
              MeteringScreenLayoutFeature.extremeExposurePairs: true,
              MeteringScreenLayoutFeature.filmPicker: true,
            }.toJson(),
          ),
        });
      });

      group(
        'Select film',
        () {
          testMeteringPicker<FilmPicker, Film>(
            'with the same ISO',
            expectBefore: MeteringValuesExpectation(
              mockPhotoFastestExposurePair.toString(),
              mockPhotoSlowestExposurePair.toString(),
              mockPhotoEv100,
            ),
            valueToSelect: mockFilms[0].name,
            expectAfter: MeteringValuesExpectation(
              mockPhotoFastestExposurePair.toString(),
              '$mockPhotoSlowestAperture - ${mockFilms[0].reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
              mockPhotoEv100,
            ),
          );

          testMeteringPicker<FilmPicker, Film>(
            'with greater ISO',
            expectBefore: MeteringValuesExpectation(
              mockPhotoFastestExposurePair.toString(),
              mockPhotoSlowestExposurePair.toString(),
              mockPhotoEv100,
            ),
            valueToSelect: mockFilms[1].name,
            expectAfter: MeteringValuesExpectation(
              mockPhotoFastestExposurePair.toString(),
              '$mockPhotoSlowestAperture - ${mockFilms[1].reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
              mockPhotoEv100,
            ),
          );
        },
      );

      testMeteringPicker<IsoValuePicker, IsoValue>(
        'Select ISO +1 EV',
        expectBefore: MeteringValuesExpectation(
          mockPhotoFastestExposurePair.toString(),
          mockPhotoSlowestExposurePair.toString(),
          mockPhotoEv100,
        ),
        valueToSelect: '400',
        expectAfter: MeteringValuesExpectation(
          '$mockPhotoFastestAperture - 1/1250',
          '$mockPhotoSlowestAperture - 1.6"',
          mockPhotoEv100 + 2,
        ),
      );

      testMeteringPicker<NdValuePicker, NdValue>(
        'Select ND -1 EV',
        expectBefore: MeteringValuesExpectation(
          mockPhotoFastestExposurePair.toString(),
          mockPhotoSlowestExposurePair.toString(),
          mockPhotoEv100,
        ),
        valueToSelect: '2',
        expectAfter: MeteringValuesExpectation(
          '$mockPhotoFastestAperture - 1/160',
          '$mockPhotoSlowestAperture - 13"',
          mockPhotoEv100 - 1,
        ),
      );

      testWidgets(
        description,
        (tester) async {
          Future<void> selectAndExpect<P, V>(
            String valueToSelect,
            MeteringValuesExpectation expectation, {
            String? reason,
          }) async {
            /// Verify, that EV is recalculated with a new setting
            await tester.openPickerAndSelect<P, V>(valueToSelect);
            _expectPickerTitle<P>(valueToSelect);
            expectExposurePairsContainer(expectation.fastestExposurePair, expectation.slowestExposurePair);
            expectMeasureButton(expectation.ev);

            /// Make sure, that the selected setting is applied in the subsequent measurements
            await tester.takePhoto();
            await tester.takePhoto();
            expectExposurePairsContainer(expectation.fastestExposurePair, expectation.slowestExposurePair);
            expectMeasureButton(expectation.ev);
          }

          await tester.pumpApplication();
          await tester.takePhoto();

          await selectAndExpect<IsoValuePicker, IsoValue>(
            '400',
            MeteringValuesExpectation(
              '$mockPhotoFastestAperture - 1/1250',
              '$mockPhotoSlowestAperture - 1.6"',
              mockPhotoEv100 + 2,
            ),
            reason: 'Selecting ISO value must change EV value and therefore exposure pairs.',
          );

          await selectAndExpect<NdValuePicker, NdValue>(
            '2',
            MeteringValuesExpectation(
              '$mockPhotoFastestAperture - 1/640',
              '$mockPhotoSlowestAperture - 3"',
              mockPhotoEv100 - 1,
            ),
            reason: 'Selecting ND value must change EV value and therefore exposure pairs.',
          );

          await selectAndExpect<FilmPicker, Film>(
            mockFilms[0].name,
            MeteringValuesExpectation(
              mockPhotoFastestExposurePair.toString(),
              '$mockPhotoSlowestAperture - ${mockFilms[0].reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
              mockPhotoEv100,
            ),
            reason: 'Selecting with the same ISO must change nothing exept exposure pairs due to reciprocity.',
          );
          await selectAndExpect<FilmPicker, Film>(
            mockFilms[1].name,
            MeteringValuesExpectation(
              mockPhotoFastestExposurePair.toString(),
              '$mockPhotoSlowestAperture - ${mockFilms[0].reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
              mockPhotoEv100,
            ),
            reason:
                'Selecting with a different ISO must must indicate push/pull and can change nothing exept exposure pairs due to reciprocity.',
          );
        },
      );
    },
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

      // Verify initial EV
      await tester.toggleIncidentMetering(expectBefore.ev);
      expectExposurePairsContainer(expectBefore.fastestExposurePair, expectBefore.slowestExposurePair);
      expectMeasureButton(expectBefore.ev);

      /// Verify, that EV is recalculated with a new setting
      await tester.openPickerAndSelect<P, V>(valueToSelect);
      expectExposurePairsContainer(expectAfter.fastestExposurePair, expectAfter.slowestExposurePair);
      expectMeasureButton(expectAfter.ev);

      /// Make sure, that the selected setting is applied in the subsequent measurements
      await tester.toggleIncidentMetering(expectBefore.ev);
      expectExposurePairsContainer(expectAfter.fastestExposurePair, expectAfter.slowestExposurePair);
      expectMeasureButton(expectAfter.ev);
    },
    skip: skip,
  );
}

extension on WidgetTester {
  Future<void> openPickerAndSelect<P, V>(String valueToSelect) async {
    await openAnimatedPicker<P>();
    await tapDescendantTextOf<DialogPicker<V>>(valueToSelect);
    await tapSelectButton();
  }
}

void _expectPickerTitle<T>(String title, {String? reason}) {
  expect(find.descendant(of: find.byType(T), matching: find.text(title)), findsOneWidget, reason: reason);
}

void expectExposurePairsContainer(String fastest, String slowest) {
  final pickerFinder = find.byType(ExtremeExposurePairsContainer);
  expect(pickerFinder, findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(S.current.fastestExposurePair)), findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(fastest)), findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(S.current.slowestExposurePair)), findsOneWidget);
  expect(find.descendant(of: pickerFinder, matching: find.text(slowest)), findsOneWidget);
}

void expectMeasureButton(double ev) {
  find.descendant(
    of: find.byType(MeteringMeasureButton),
    matching: find.text('${ev.toStringAsFixed(1)}\n${S.current.ev}'),
  );
}
