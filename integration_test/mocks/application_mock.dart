import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

class ApplicationMock extends StatelessWidget {
  final Environment env;
  final CaffeineService caffeineService;
  final HapticsService hapticsService;
  final LightSensorService lightSensorService;
  final PermissionsService permissionsService;
  final UserPreferencesService userPreferencesService;
  final VolumeEventsService volumeEventsService;

  const ApplicationMock(
    this.env, {
    required this.caffeineService,
    required this.hapticsService,
    required this.lightSensorService,
    required this.permissionsService,
    required this.userPreferencesService,
    required this.volumeEventsService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IAPProviders(
      sharedPreferences: _MockSharedPreferences(),
      child: IAPProducts(
        products: [
          IAPProduct(
            storeId: IAPProductType.paidFeatures.storeId,
            status: IAPProductStatus.purchased,
          )
        ],
        child: EquipmentProfiles(
          selected: _equipmentProfiles[1],
          values: _equipmentProfiles,
          child: Films(
            selected: Film('Ilford HP+', 400),
            values: [Film.other(), Film('Ilford HP+', 400)],
            filmsInUse: [Film.other(), Film('Ilford HP+', 400)],
            child: ServicesProvider(
              caffeineService: caffeineService,
              environment: env,
              hapticsService: hapticsService,
              lightSensorService: lightSensorService,
              permissionsService: permissionsService,
              userPreferencesService: userPreferencesService,
              volumeEventsService: volumeEventsService,
              child: UserPreferencesProvider(
                child: Builder(
                  builder: (context) {
                    final theme = UserPreferencesProvider.themeOf(context);
                    final systemIconsBrightness =
                        ThemeData.estimateBrightnessForColor(theme.colorScheme.onSurface);
                    return AnnotatedRegion(
                      value: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: systemIconsBrightness == Brightness.light
                            ? Brightness.dark
                            : Brightness.light,
                        statusBarIconBrightness: systemIconsBrightness,
                        systemNavigationBarColor: Colors.transparent,
                        systemNavigationBarIconBrightness: systemIconsBrightness,
                      ),
                      child: MaterialApp(
                        theme: theme,
                        locale: Locale(UserPreferencesProvider.localeOf(context).intlName),
                        localizationsDelegates: const [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                          child: child!,
                        ),
                        initialRoute: "metering",
                        routes: {
                          "metering": (context) => const MeteringFlow(),
                          "settings": (context) => const SettingsFlow(),
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final _equipmentProfiles = [
  const EquipmentProfile(
    id: '',
    name: '',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  ),
  EquipmentProfile(
    id: '1',
    name: 'Praktikca + Zenitar',
    apertureValues: ApertureValue.values.sublist(
      ApertureValue.values.indexOf(const ApertureValue(1.7, StopType.half)),
      ApertureValue.values.indexOf(const ApertureValue(16, StopType.full)),
    ),
    ndValues: NdValue.values.sublist(0, 3),
    shutterSpeedValues: ShutterSpeedValue.values.sublist(
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(1000, true, StopType.full)),
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(16, false, StopType.full)),
    ),
    isoValues: const [
      IsoValue(50, StopType.full),
      IsoValue(100, StopType.full),
      IsoValue(200, StopType.full),
      IsoValue(250, StopType.third),
      IsoValue(400, StopType.full),
      IsoValue(500, StopType.third),
      IsoValue(800, StopType.full),
      IsoValue(1600, StopType.full),
      IsoValue(3200, StopType.full),
    ],
  ),
  const EquipmentProfile(
    id: '2',
    name: 'Praktica + Jupiter',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  ),
];
