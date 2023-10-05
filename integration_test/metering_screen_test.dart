import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/application.dart';
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
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/nd_picker/widget_picker_nd.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockCaffeineService extends Mock implements CaffeineService {}

class _MockHapticsService extends Mock implements HapticsService {}

class _MockPermissionsService extends Mock implements PermissionsService {}

class _MockLightSensorService extends Mock implements LightSensorService {}

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

const _defaultIsoValue = IsoValue(400, StopType.full);

//https://stackoverflow.com/a/67186625/13167574
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockCaffeineService mockCaffeineService;
  late _MockHapticsService mockHapticsService;
  late _MockPermissionsService mockPermissionsService;
  late _MockLightSensorService mockLightSensorService;
  late _MockVolumeEventsService mockVolumeEventsService;

  setUpAll(() {
    mockUserPreferencesService = _MockUserPreferencesService();
    when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.camera);
    when(() => mockUserPreferencesService.stopType).thenReturn(StopType.third);
    when(() => mockUserPreferencesService.locale).thenReturn(SupportedLocale.en);
    when(() => mockUserPreferencesService.caffeine).thenReturn(true);
    when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
    when(() => mockUserPreferencesService.cameraEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.lightSensorEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.iso).thenReturn(_defaultIsoValue);
    when(() => mockUserPreferencesService.ndFilter).thenReturn(NdValue.values.first);
    when(() => mockUserPreferencesService.haptics).thenReturn(true);
    when(() => mockUserPreferencesService.meteringScreenLayout).thenReturn({
      MeteringScreenLayoutFeature.equipmentProfiles: true,
      MeteringScreenLayoutFeature.extremeExposurePairs: true,
      MeteringScreenLayoutFeature.filmPicker: true,
      MeteringScreenLayoutFeature.histogram: false,
    });
    when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
    when(() => mockUserPreferencesService.primaryColor).thenReturn(primaryColorsList[5]);
    when(() => mockUserPreferencesService.dynamicColor).thenReturn(false);

    mockCaffeineService = _MockCaffeineService();
    when(() => mockCaffeineService.isKeepScreenOn()).thenAnswer((_) async => false);
    when(() => mockCaffeineService.keepScreenOn(true)).thenAnswer((_) async => true);
    when(() => mockCaffeineService.keepScreenOn(false)).thenAnswer((_) async => false);

    mockHapticsService = _MockHapticsService();
    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});

    mockPermissionsService = _MockPermissionsService();
    when(() => mockPermissionsService.requestCameraPermission()).thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockPermissionsService.checkCameraPermission()).thenAnswer((_) async => PermissionStatus.granted);

    mockLightSensorService = _MockLightSensorService();
    when(() => mockLightSensorService.hasSensor()).thenAnswer((_) async => true);
    when(() => mockLightSensorService.luxStream()).thenAnswer((_) => Stream.fromIterable([100]));

    mockVolumeEventsService = _MockVolumeEventsService();
    when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
    when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
    when(() => mockVolumeEventsService.volumeButtonsEventStream()).thenAnswer((_) => const Stream<int>.empty());

    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
  });

  Future<void> pumpApplication(WidgetTester tester, IAPProductStatus purchaseStatus) async {
    await tester.pumpWidget(
      MockIAPProviders(
        purchaseStatus: purchaseStatus,
        child: ServicesProvider(
          environment: const Environment.prod().copyWith(hasLightSensor: true),
          userPreferencesService: mockUserPreferencesService,
          caffeineService: mockCaffeineService,
          hapticsService: mockHapticsService,
          permissionsService: mockPermissionsService,
          lightSensorService: mockLightSensorService,
          volumeEventsService: mockVolumeEventsService,
          child: const UserPreferencesProvider(
            child: Application(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group(
    'AnimatedDialog picker standalone tests',
    () {
      setUpAll(() {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.sensor);
        when(() => mockUserPreferencesService.iso).thenReturn(_defaultIsoValue);
        when(() => mockUserPreferencesService.iso = _defaultIsoValue).thenReturn(_defaultIsoValue);
      });

      testWidgets(
        'Open & close with select',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchasable);
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapSelectButton();
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );

      testWidgets(
        'Open & close with cancel',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchasable);
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
          await tester.tapCancelButton();
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );

      testWidgets(
        'Open & close with tap outside',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchasable);
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);

          /// tester taps the center of the found widget,
          /// which results in tap on the dialog instead of the underlying barrier
          /// therefore just tap at offset outside the dialog
          await tester.longPressAt(const Offset(16, 16));
          await tester.pumpAndSettle(Dimens.durationML);
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );

      testWidgets(
        'Open & close with back gesture',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchasable);
          await tester.openAnimatedPicker<IsoValuePicker>();
          expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);

          //// https://github.com/flutter/flutter/blob/master/packages/flutter/test/widgets/router_test.dart#L970-L971
          //// final ByteData message = const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute'));
          //// await tester.binding.defaultBinaryMessenger.handlePlatformMessage('flutter/navigation', message, (_) {});
          /// https://github.com/flutter/packages/blob/main/packages/animations/test/open_container_test.dart#L234
          (tester.state(find.byType(Navigator)) as NavigatorState).pop();
          await tester.pumpAndSettle(Dimens.durationML);
          expect(find.byType(DialogPicker<IsoValue>), findsNothing);
        },
      );
    },
  );

  group(
    'Free version',
    () {
      testWidgets(
        'Initial state',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchasable);
          expectAnimatedPicker<EquipmentProfilePicker>(S.current.equipmentProfile, S.current.none);
          expectAnimatedPicker<FilmPicker>(S.current.film, S.current.none);
          expectAnimatedPicker<IsoValuePicker>(S.current.iso, '400');
          expectAnimatedPicker<NdValuePicker>(S.current.nd, S.current.none);

          await tester.openAnimatedPicker<EquipmentProfilePicker>();
          expect(find.byType(DialogPicker<EquipmentProfile>), findsOneWidget);
          // expect None selected and no other profiles present
          await tester.tapCancelButton();
          expect(find.byType(DialogPicker<EquipmentProfile>), findsNothing);

          await tester.openAnimatedPicker<FilmPicker>();
          await tester.openAnimatedPicker<IsoValuePicker>();
          await tester.openAnimatedPicker<NdValuePicker>();
        },
      );
    },
    skip: true,
  );

  group(
    'Pro version',
    () {
      testWidgets(
        'Initial state',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchased);
        },
      );

      testWidgets(
        'Film (push/pull)',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchased);
        },
      );
    },
    skip: true,
  );
}

extension WidgetTesterActions on WidgetTester {
  Future<void> openAnimatedPicker<T>() async {
    await tap(find.byType(T));
    await pumpAndSettle(Dimens.durationL);
  }

  Future<void> tapSelectButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == S.current.select,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle();
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) => widget is TextButton && widget.child is Text && (widget.child as Text?)?.data == S.current.cancel,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle();
  }
}
