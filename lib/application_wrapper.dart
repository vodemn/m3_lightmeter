import 'package:flutter/material.dart';
import 'package:lightmeter/data/analytics/analytics.dart';
import 'package:lightmeter/data/analytics/api/analytics_firebase.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/remote_config_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationWrapper extends StatelessWidget {
  final Environment env;
  final Widget child;

  const ApplicationWrapper(this.env, {required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final remoteConfigService = env.buildType != BuildType.dev
        ? const RemoteConfigService(LightmeterAnalytics(api: LightmeterAnalyticsFirebase()))
        : const MockRemoteConfigService();
    final filmsStorageService = FilmsStorageService();
    return FutureBuilder(
      future: Future.wait<dynamic>([
        SharedPreferences.getInstance(),
        const LightSensorService(LocalPlatform()).hasSensor(),
        remoteConfigService.activeAndFetchFeatures(),
        filmsStorageService.init(),
      ]),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          final iapService = IAPStorageService(snapshot.data![0] as SharedPreferences);
          final userPreferencesService = UserPreferencesService(snapshot.data![0] as SharedPreferences);
          final hasLightSensor = snapshot.data![1] as bool;
          return ServicesProvider(
            analytics: const LightmeterAnalytics(api: LightmeterAnalyticsFirebase()),
            caffeineService: const CaffeineService(),
            environment: env.copyWith(hasLightSensor: hasLightSensor),
            hapticsService: const HapticsService(),
            lightSensorService: const LightSensorService(LocalPlatform()),
            permissionsService: const PermissionsService(),
            userPreferencesService: userPreferencesService,
            volumeEventsService: const VolumeEventsService(LocalPlatform()),
            filmsStorageService: filmsStorageService,
            child: RemoteConfigProvider(
              remoteConfigService: remoteConfigService,
              child: EquipmentProfileProvider(
                storageService: iapService,
                child: FilmsProvider(
                  filmsStorageService: filmsStorageService,
                  storageService: iapService,
                  child: UserPreferencesProvider(
                    hasLightSensor: hasLightSensor,
                    userPreferencesService: userPreferencesService,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return Center(child: Text(snapshot.error!.toString()));
        }

        // TODO(@vodemn): maybe user splashscreen instead
        return const SizedBox();
      },
    );
  }
}
