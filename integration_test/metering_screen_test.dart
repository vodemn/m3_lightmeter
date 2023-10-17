import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/camera_container/widget_container_camera.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';
import 'utils/platform_channel_mock.dart';
import 'utils/widget_tester_actions.dart';

const defaultIsoValue = IsoValue(100, StopType.full);
const mockPhotoEv100 = 8.3;
const mockPhotoFastestAperture = ApertureValue(1, StopType.full);
const mockPhotoSlowestAperture = ApertureValue(45, StopType.full);
const mockPhotoFastestShutterSpeed = ShutterSpeedValue(320, true, StopType.third);
const mockPhotoSlowestShutterSpeed = ShutterSpeedValue(6, false, StopType.third);
const mockPhotoFastestExposurePair = ExposurePair(mockPhotoFastestAperture, mockPhotoFastestShutterSpeed);
const mockPhotoSlowestExposurePair = ExposurePair(mockPhotoSlowestAperture, mockPhotoSlowestShutterSpeed);

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

          /// Verify that [LightSensorContainer] is shown in correspondance with the saved ev source
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

          /// Verify that [CameraContainer] is shown instead of [LightSensorContainer]
          expect(find.byType(CameraContainer), findsOneWidget);

          /// and there is no ability to switch to the incident metering
          expect(find.byTooltip(S.current.tooltipUseLightSensor), findsNothing);
        },
        skip: Platform.isIOS,
      );

      testWidgets(
        'iOS - no sensor',
        (tester) async {
          SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.sensor.index});
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);

          /// verify no button to switch to the incident light mode
          expect(find.byType(CameraContainer), findsOneWidget);

          /// and there is no ability to switch to the incident metering
          expect(find.byTooltip(S.current.tooltipUseLightSensor), findsNothing);
        },
        skip: Platform.isAndroid,
      );
    },
  );

  group(
    '[Match extreme exposure pairs & pairs list edge values]',
    () {
      Future<List<ExposurePair>> scrollToTheLastExposurePair(WidgetTester tester) async {
        final exposurePairs = MeteringContainerBuidler.buildExposureValues(
          mockPhotoEv100,
          StopType.third,
          defaultEquipmentProfile,
        );
        await tester.scrollUntilVisible(
          find.byWidgetPredicate((widget) => widget is Row && widget.key == ValueKey(exposurePairs.length - 1)),
          56,
          scrollable: find.descendant(of: find.byType(ExposurePairsList), matching: find.byType(Scrollable)),
        );
        return exposurePairs;
      }

      void expectExposurePairsListItem(int index, String aperture, String shutterSpeed) {
        final firstPairRow = find.byWidgetPredicate((widget) => widget is Row && widget.key == ValueKey(index));
        expect(find.descendant(of: firstPairRow, matching: find.text(aperture)), findsOneWidget);
        expect(find.descendant(of: firstPairRow, matching: find.text(shutterSpeed)), findsOneWidget);
      }

      setUpAll(() {
        SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index});
      });

      testWidgets(
        'No exposure pairs',
        (tester) async {
          await tester.pumpApplication(productStatus: IAPProductStatus.purchasable);

          /// Verify that no exposure pairs are shown in [ExtremeExposurePairsContainer]
          final pickerFinder = find.byType(ExtremeExposurePairsContainer);
          expect(pickerFinder, findsOneWidget);
          expect(find.descendant(of: pickerFinder, matching: find.text(S.current.fastestExposurePair)), findsOneWidget);
          expect(find.descendant(of: pickerFinder, matching: find.text(S.current.slowestExposurePair)), findsOneWidget);
          expect(find.descendant(of: pickerFinder, matching: find.text('-')), findsNWidgets(2));

          /// Verify that the exposure pairs list is empty
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

          /// Verify that reciprocity is not applied to the slowest exposure pair in the container
          expectExposurePairsContainer('$mockPhotoFastestAperture - 1/320', '$mockPhotoSlowestAperture - 6"');
          expectMeasureButton(mockPhotoEv100);

          /// Verify that reciprocity is not applied to the slowest exposure pair in the list
          expectExposurePairsListItem(0, '$mockPhotoFastestAperture', '1/320');
          final exposurePairs = await scrollToTheLastExposurePair(tester);
          expectExposurePairsListItem(exposurePairs.length - 1, '$mockPhotoSlowestAperture', '6"');
          expectMeasureButton(mockPhotoEv100);
        },
      );

      testWidgets(
        'Multiple exposure pairs w/ reciprocity',
        (tester) async {
          await tester.pumpApplication(selectedFilm: mockFilms.first);
          await tester.takePhoto();

          /// Verify that reciprocity is applied to the slowest exposure pair in the container
          expectExposurePairsContainer('$mockPhotoFastestAperture - 1/320', '$mockPhotoSlowestAperture - 12"');
          expectMeasureButton(mockPhotoEv100);

          /// Verify that reciprocity is applied to the slowest exposure pair in the list
          expectExposurePairsListItem(0, '$mockPhotoFastestAperture', '1/320');
          final exposurePairs = await scrollToTheLastExposurePair(tester);
          expectExposurePairsListItem(exposurePairs.length - 1, '$mockPhotoSlowestAperture', '12"');
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
            await tester.pumpApplication();
            await tester.takePhoto();

            // Verify that reciprocity failure is applies for the film is not selected
            expectAnimatedPickerWith<FilmPicker>(title: S.current.film, value: S.current.none);
            expectExposurePairsContainer('$mockPhotoFastestExposurePair', '$mockPhotoSlowestExposurePair');
            expectMeasureButton(mockPhotoEv100);

            await tester.openAnimatedPicker<FilmPicker>();
            await tester.tapDescendantTextOf<DialogPicker<Film>>(mockFilms.first.name);
            await tester.tapSelectButton();

            /// Verify that exposure pairs are the same, except that the reciprocity failure is applied
            expectExposurePairsContainer(
              '$mockPhotoFastestExposurePair',
              '$mockPhotoSlowestAperture - ${mockFilms.first.reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
            );
            expectMeasureButton(mockPhotoEv100);

            /// Make sure, that the EV is not changed
            await tester.takePhoto();
            expectExposurePairsContainer(
              '$mockPhotoFastestExposurePair',
              '$mockPhotoSlowestAperture - ${mockFilms.first.reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
            );
            expectMeasureButton(mockPhotoEv100);
          },
        );

        testWidgets(
          'with greater ISO',
          (tester) async {
            await tester.pumpApplication();
            await tester.takePhoto();

            // Verify that reciprocity failure is applies for the film is not selected
            expectAnimatedPickerWith<FilmPicker>(title: S.current.film, value: S.current.none);
            expectExposurePairsContainer('$mockPhotoFastestExposurePair', '$mockPhotoSlowestExposurePair');
            expectMeasureButton(mockPhotoEv100);

            await tester.openAnimatedPicker<FilmPicker>();
            await tester.tapDescendantTextOf<DialogPicker<Film>>(mockFilms[1].name);
            await tester.tapSelectButton();

            /// Verify that exposure pairs are the same, except that the reciprocity failure is applied
            expectExposurePairsContainer(
              '$mockPhotoFastestExposurePair',
              '$mockPhotoSlowestAperture - ${mockFilms[1].reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
            );
            expectMeasureButton(mockPhotoEv100);

            /// Make sure, that the EV is not changed
            await tester.takePhoto();
            expectExposurePairsContainer(
              '$mockPhotoFastestExposurePair',
              '$mockPhotoSlowestAperture - ${mockFilms[1].reciprocityFailure(mockPhotoSlowestShutterSpeed)}',
            );
            expectMeasureButton(mockPhotoEv100);
          },
        );
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
        skip: true,
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
        skip: true,
      );
    },
  );
}
