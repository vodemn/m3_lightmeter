import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/widget_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';
import 'utils/platform_channel_mock.dart';
import 'utils/widget_tester_actions.dart';

const defaultIsoValue = IsoValue(400, StopType.full);
const mockPhotoEv100 = 8.3;
const fastestExposurePairMockPhoto = "f/1.0 - 1/320";

//https://stackoverflow.com/a/67186625/13167574
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    '[Light sensor availability]',
    () {
      testWidgets(
        'Android - has sensor',
        (tester) async {
          SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.sensor.index});
          setLightSensorAvilability(hasSensor: true);
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);

          // verify no button to switch to the incident light mode
          expect(find.byType(LightSensorContainer), findsOneWidget);
        },
        skip: Platform.isIOS,
      );

      testWidgets(
        'Android - no sensor',
        (tester) async {
          SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.sensor.index});
          setLightSensorAvilability(hasSensor: false);
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);

          // verify no button to switch to the incident light mode
          expect(find.byTooltip(S.current.tooltipUseLightSensor), findsNothing);
        },
        skip: Platform.isIOS,
      );

      testWidgets(
        'iOS - no sensor',
        (tester) async {
          SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.sensor.index});
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);

          // verify no button to switch to the incident light mode
          expect(find.byTooltip(S.current.tooltipUseLightSensor), findsNothing);
        },
        skip: Platform.isAndroid,
      );
    },
  );

  group(
    '[Match extreme exposure pairs & pairs list edge values]',
    () {
      void expectExposurePairsListItem(int index, String aperture, String shutterSpeed) {
        final firstPairRow = find.byWidgetPredicate(
          (widget) => widget is Row && widget.key == ValueKey(index),
        );
        expect(
          find.descendant(of: firstPairRow, matching: find.text(aperture)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: firstPairRow, matching: find.text(shutterSpeed)),
          findsOneWidget,
        );
      }

      setUpAll(() {
        SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index});
      });

      testWidgets(
        'No exposure pairs',
        (tester) async {
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);

          final pickerFinder = find.byType(ExtremeExposurePairsContainer);
          expect(pickerFinder, findsOneWidget);
          expect(
            find.descendant(of: pickerFinder, matching: find.text(S.current.fastestExposurePair)),
            findsOneWidget,
          );
          expect(
            find.descendant(of: pickerFinder, matching: find.text(S.current.slowestExposurePair)),
            findsOneWidget,
          );
          expect(find.descendant(of: pickerFinder, matching: find.text('-')), findsNWidgets(2));

          expect(
            find.descendant(
              of: find.byType(ExposurePairsList),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is IconPlaceholder &&
                    widget.icon == Icons.not_interested &&
                    widget.text == S.current.noExposurePairs,
              ),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Multiple exposure pairs w/o reciprocity',
        (tester) async {
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);
          await tester.takePhoto();

          expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 6"');
          expectExposurePairsListItem(0, 'f/1.0', '1/320');
          expectMeasureButton(mockPhotoEv100);

          final exposurePairs = MeteringContainerBuidler.buildExposureValues(
            mockPhotoEv100,
            StopType.third,
            defaultEquipmentProfile,
          );
          await tester.scrollUntilVisible(
            find.byWidgetPredicate(
              (widget) => widget is Row && widget.key == ValueKey(exposurePairs.length - 1),
            ),
            56,
            scrollable: find.descendant(
              of: find.byType(ExposurePairsList),
              matching: find.byType(Scrollable),
            ),
          );
          expectExposurePairsListItem(exposurePairs.length - 1, 'f/45', '6"');
          expectMeasureButton(mockPhotoEv100);
        },
      );

      testWidgets(
        'Multiple exposure pairs w/ reciprocity',
        (tester) async {
          await tester.pumpApplication(selectedFilm: mockFilms.first);
          await tester.takePhoto();

          expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 12"');
          expectExposurePairsListItem(0, 'f/1.0', '1/320');
          expectMeasureButton(mockPhotoEv100);

          final exposurePairs = MeteringContainerBuidler.buildExposureValues(
            mockPhotoEv100,
            StopType.third,
            defaultEquipmentProfile,
          );
          await tester.scrollUntilVisible(
            find.byWidgetPredicate(
              (widget) => widget is Row && widget.key == ValueKey(exposurePairs.length - 1),
            ),
            56,
            scrollable: find.descendant(
              of: find.byType(ExposurePairsList),
              matching: find.byType(Scrollable),
            ),
          );
          expectExposurePairsListItem(exposurePairs.length - 1, 'f/45', '12"');
          expectMeasureButton(mockPhotoEv100);
        },
      );
    },
  );

  group(
    '[Pickers tests]',
    () {
      group('Select film', () {
        testWidgets(
          'with the same ISO',
          (tester) async {
            await tester.pumpApplication(productStatus: IAPProductStatus.purchased);
            expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 13"');
            expectMeasureButton(mockPhotoEv100);

            await tester.openAnimatedPicker<FilmPicker>();
            expect(find.byType(DialogPicker<Film>), findsOneWidget);
            await tester.tapSelectButton();
            expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 13"');
            expectMeasureButton(mockPhotoEv100);

            /// Make sure, that nothing is changed
            await tester.tap(find.byType(MeteringMeasureButton));
            await tester.tap(find.byType(MeteringMeasureButton));
            await tester.pumpAndSettle();
            expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 13"');
            expectMeasureButton(mockPhotoEv100);
          },
        );

        /// Select film with iso > current
      });

      testWidgets(
        'Select ISO +1 EV',
        (tester) async {
          await tester.pumpApplication(productStatus: IAPProductStatus.purchased);
          expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 13"');
          expectMeasureButton(mockPhotoEv100);

          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapRadioListTile<IsoValue>('800');
          await tester.tapSelectButton();
          expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 6"');
          expectMeasureButton(8.3);

          /// Make sure, that current ISO is used in metering
          await tester.tap(find.byType(MeteringMeasureButton));
          await tester.tap(find.byType(MeteringMeasureButton));
          await tester.pumpAndSettle();
          expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 6"');
          expectMeasureButton(8.3);
        },
      );

      testWidgets(
        'Select ND -1 EV',
        (tester) async {
          await tester.pumpApplication(productStatus: IAPProductStatus.purchased);
          expectExposurePairsContainer('f/1.0 - 1/320', 'f/45 - 13"');
          expectMeasureButton(mockPhotoEv100);

          await tester.openAnimatedPicker<NdValuePicker>();
          expect(find.byType(DialogPicker<NdValue>), findsOneWidget);
          await tester.tapRadioListTile<NdValue>('2');
          await tester.tapSelectButton();
          expectExposurePairsContainer('f/1.0 - 1/80', 'f/36 - 16"');
          expectMeasureButton(6.3);

          /// Make sure, that current ISO is used in metering
          await tester.tap(find.byType(MeteringMeasureButton));
          await tester.tap(find.byType(MeteringMeasureButton));
          await tester.pumpAndSettle();
          expectExposurePairsContainer('f/1.0 - 1/80', 'f/36 - 16"');
          expectMeasureButton(6.3);
        },
      );
    },
    skip: true,
  );
}

extension _WidgetTesterActions on WidgetTester {
  Future<void> tapRadioListTile<T>(String value) async {
    expect(find.descendant(of: find.byType(RadioListTile<T>), matching: find.text(value)), findsOneWidget);
    await tap(find.descendant(of: find.byType(RadioListTile<T>), matching: find.text(value)));
  }
}
