import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/camera_container/widget_container_camera.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/widget_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';
import 'utils/metering_picker_test.dart';
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

  tearDown(() {
    SharedPreferences.resetStatic();
  });

  group(
    '[Light sensor availability]',
    () {
      tearDown(() {
        resetLightSensorAvilability();
      });

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

      setUp(() {
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
      setUpAll(() {
        setupLightSensorStreamHandler();
        setLightSensorAvilability(hasSensor: true);
      });

      tearDownAll(() {
        resetLightSensorAvilability();
        resetLightSensorStreamHandler();
      });

      setUp(() {
        SharedPreferences.setMockInitialValues({UserPreferencesService.evSourceTypeKey: EvSourceType.sensor.index});
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
    },
  );
}
