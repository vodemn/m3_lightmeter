import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:lightmeter/data/analytics/analytics.dart';
import 'package:lightmeter/data/analytics/api/analytics_firebase.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/remote_config_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/mocks/paid_features_mock.dart';
import '../integration_test/utils/platform_channel_mock.dart';

/// Provides [MaterialApp] with default theme and "en" localization
class WidgetTestApplicationMock extends StatelessWidget {
  final Widget child;

  const WidgetTestApplicationMock({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeFrom(primaryColorsList[5], Brightness.light),
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: child!,
      ),
      home: Scaffold(body: child),
    );
  }
}

class GoldenTestApplicationMock extends StatefulWidget {
  final IAPProductStatus productStatus;
  final Widget child;

  const GoldenTestApplicationMock({
    this.productStatus = IAPProductStatus.purchased,
    required this.child,
    super.key,
  });

  @override
  State<GoldenTestApplicationMock> createState() => _GoldenTestApplicationMockState();
}

class _GoldenTestApplicationMockState extends State<GoldenTestApplicationMock> {
  @override
  void initState() {
    super.initState();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      LightSensor.methodChannel,
      (methodCall) async {
        switch (methodCall.method) {
          case "sensor":
            return true;
          default:
            return null;
        }
      },
    );
    setupLightSensorStreamHandler();
  }

  @override
  void dispose() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      LightSensor.methodChannel,
      null,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IAPProducts(
      products: [
        IAPProduct(
          storeId: IAPProductType.paidFeatures.storeId,
          status: widget.productStatus,
          price: '0.0\$',
        ),
      ],
      child: _MockApplicationWrapper(
        child: MockIAPProviders(
          selectedEquipmentProfileId: mockEquipmentProfiles.first.id,
          selectedFilmId: mockFilms.first.id,
          child: Builder(
            builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: UserPreferencesProvider.themeOf(context),
                locale: Locale(UserPreferencesProvider.localeOf(context).intlName),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                  child: child!,
                ),
                home: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MockApplicationWrapper extends StatelessWidget {
  final Widget child;

  const _MockApplicationWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          final userPreferencesService = UserPreferencesService(snapshot.data!);
          return ServicesProvider(
            analytics: const LightmeterAnalytics(api: LightmeterAnalyticsFirebase()),
            caffeineService: const CaffeineService(),
            environment: const Environment.dev().copyWith(hasLightSensor: true),
            hapticsService: const HapticsService(),
            lightSensorService: const LightSensorService(LocalPlatform()),
            permissionsService: const PermissionsService(),
            userPreferencesService: userPreferencesService,
            volumeEventsService: const VolumeEventsService(LocalPlatform()),
            child: RemoteConfigProvider(
              remoteConfigService: const MockRemoteConfigService(),
              child: UserPreferencesProvider(
                hasLightSensor: true,
                userPreferencesService: userPreferencesService,
                child: child,
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
