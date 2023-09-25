import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mocks/application_mock.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockCaffeineService extends Mock implements CaffeineService {}

class _MockHapticsService extends Mock implements HapticsService {}

class _MockPermissionsService extends Mock implements PermissionsService {}

class _MockLightSensorService extends Mock implements LightSensorService {}

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

class _MockMeteringBloc extends Mock implements MeteringBloc {}

void main() {
  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockCaffeineService mockCaffeineService;
  late _MockHapticsService mockHapticsService;
  late _MockPermissionsService mockPermissionsService;
  late _MockLightSensorService mockLightSensorService;
  late _MockVolumeEventsService mockVolumeEventsService;

  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late _MockMeteringBloc meteringBloc;

  const meteringBlocState = MeteringDataState(
    ev100: 7.7,
    iso: IsoValue(400, StopType.full),
    nd: NdValue(0),
    isMetering: false,
  );

  setUpAll(() {
    mockUserPreferencesService = _MockUserPreferencesService();

    when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.sensor);
    when(() => mockUserPreferencesService.stopType).thenReturn(StopType.third);
    when(() => mockUserPreferencesService.locale).thenReturn(SupportedLocale.en);
    when(() => mockUserPreferencesService.caffeine).thenReturn(true);
    when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
    when(() => mockUserPreferencesService.cameraEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.lightSensorEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.iso).thenReturn(const IsoValue(400, StopType.full));
    when(() => mockUserPreferencesService.ndFilter).thenReturn(NdValue.values.first);
    when(() => mockUserPreferencesService.haptics).thenReturn(true);
    when(() => mockUserPreferencesService.meteringScreenLayout).thenReturn({
      MeteringScreenLayoutFeature.equipmentProfiles: true,
      MeteringScreenLayoutFeature.extremeExposurePairs: true,
      MeteringScreenLayoutFeature.filmPicker: true,
      MeteringScreenLayoutFeature.histogram: false,
    });
    when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
    when(() => mockUserPreferencesService.dynamicColor).thenReturn(false);

    mockCaffeineService = _MockCaffeineService();
    when(() => mockCaffeineService.keepScreenOn(true)).thenAnswer((_) async => true);

    mockHapticsService = _MockHapticsService();
    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});

    mockPermissionsService = _MockPermissionsService();
    when(() => mockPermissionsService.requestCameraPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockPermissionsService.checkCameraPermission())
        .thenAnswer((_) async => PermissionStatus.granted);

    mockLightSensorService = _MockLightSensorService();
    when(() => mockLightSensorService.hasSensor()).thenAnswer((_) async => true);
    when(() => mockLightSensorService.luxStream()).thenAnswer((_) => Stream.fromIterable([100]));

    mockVolumeEventsService = _MockVolumeEventsService();
    when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
    when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
    when(() => mockVolumeEventsService.volumeButtonsEventStream())
        .thenAnswer((_) => const Stream<int>.empty());

    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});

    meteringBloc = _MockMeteringBloc();
    when(() => meteringBloc.state).thenReturn(meteringBlocState);
    whenListen(meteringBloc, Stream.fromIterable([meteringBlocState]));
    when(() => meteringBloc.close()).thenAnswer((_) async {});
  });

  group(
    '',
    () {
      const initColor = 0xff2196f3;
      setUp(() {
        when(() => mockUserPreferencesService.primaryColor).thenReturn(const Color(initColor));
      });

      testWidgets(
        '$initColor',
        (tester) async {
          await tester.pumpWidget(
            ApplicationMock(
              const Environment.prod().copyWith(hasLightSensor: true),
              userPreferencesService: mockUserPreferencesService,
              caffeineService: mockCaffeineService,
              hapticsService: mockHapticsService,
              permissionsService: mockPermissionsService,
              lightSensorService: mockLightSensorService,
              volumeEventsService: mockVolumeEventsService,
            ),
          );
          await tester.pumpAndSettle();

          //await tester.takeScreenshot(binding, '$initColor-metering-reflected');

          await tester.tap(find.byType(MeteringMeasureButton));
          await tester.tap(find.byType(MeteringMeasureButton));
          await tester.takeScreenshot(binding, '$initColor-metering-incident');

          await tester.tap(find.byType(IsoValuePicker));
          await tester.pumpAndSettle(Dimens.durationL);
          expect(find.byType(IsoValuePicker), findsOneWidget);
          await tester.takeScreenshot(binding, '$initColor-metering-iso_picker');
          final cancelButton = find.byWidgetPredicate(
            (widget) =>
                widget is TextButton &&
                widget.child is Text &&
                (widget.child as Text?)?.data == (S.current.cancel),
          );
          expect(cancelButton, findsOneWidget);
          await tester.tap(cancelButton);
          // await tester.tap(
          //   find.descendant(
          //     of: find.byWidgetPredicate(
          //       (widget) =>
          //           widget is AnimatedDialog && widget.openedChild is DialogPicker<IsoValue>,
          //     ),
          //     matching: find.byType(TextButton),
          //   ),
          // );
          await tester.pumpAndSettle(Dimens.durationML);
          await tester.pumpAndSettle();

          expect(find.byTooltip(S.current.tooltipOpenSettings), findsOneWidget);
          await tester.tap(find.byTooltip(S.current.tooltipOpenSettings));
          await tester.pumpAndSettle();
          // print("============ TAP ============");
          // expect(find.byType(SettingsScreen), findsOneWidget);
          // await tester.takeScreenshot(binding, '$initColor-settings');
          // await tester.takeScreenshot(binding, '$initColor-settings-metering_screen_layout');
          // await tester.takeScreenshot(binding, '$initColor-equipment_profiles');
          // await tester.takeScreenshot(binding, '$initColor-equipment_profiles-iso_picker');
        },
      );
    },
  );
}

extension on WidgetTester {
  Future<void> takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, String name) async {
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await pumpAndSettle();
    }
    await binding.takeScreenshot(name);
  }
}
