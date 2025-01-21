import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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

class ApplicationWrapper extends StatefulWidget {
  final Environment env;
  final Widget child;

  const ApplicationWrapper(this.env, {required this.child, super.key});

  @override
  State<ApplicationWrapper> createState() => _ApplicationWrapperState();
}

class _ApplicationWrapperState extends State<ApplicationWrapper> {
  late final remoteConfigService = widget.env.buildType != BuildType.dev
      ? const RemoteConfigService(LightmeterAnalytics(api: LightmeterAnalyticsFirebase()))
      : const MockRemoteConfigService();

  late final UserPreferencesService userPreferencesService;
  late final bool hasLightSensor;

  final equipmentProfilesStorageService = EquipmentProfilesStorageService();
  final equipmentProfilesStorageServiceCompleter = Completer<void>();

  final filmsStorageService = FilmsStorageService();
  final filmsStorageServiceCompleter = Completer<void>();

  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
    _removeSplashscreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          return Center(child: Text(snapshot.error!.toString()));
        } else if (snapshot.connectionState == ConnectionState.done) {
          return ServicesProvider(
            analytics: const LightmeterAnalytics(api: LightmeterAnalyticsFirebase()),
            caffeineService: const CaffeineService(),
            environment: widget.env.copyWith(hasLightSensor: hasLightSensor),
            hapticsService: const HapticsService(),
            lightSensorService: const LightSensorService(LocalPlatform()),
            permissionsService: const PermissionsService(),
            userPreferencesService: userPreferencesService,
            volumeEventsService: const VolumeEventsService(LocalPlatform()),
            child: RemoteConfigProvider(
              remoteConfigService: remoteConfigService,
              child: EquipmentProfilesProvider(
                storageService: equipmentProfilesStorageService,
                onInitialized: equipmentProfilesStorageServiceCompleter.complete,
                child: FilmsProvider(
                  storageService: filmsStorageService,
                  onInitialized: filmsStorageServiceCompleter.complete,
                  child: UserPreferencesProvider(
                    hasLightSensor: hasLightSensor,
                    userPreferencesService: userPreferencesService,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Future<void> _initialize() async {
    await Future.wait([
      SharedPreferences.getInstance(),
      const LightSensorService(LocalPlatform()).hasSensor(),
      remoteConfigService.activeAndFetchFeatures(),
      equipmentProfilesStorageService.init(),
      filmsStorageService.init(),
    ]).then((value) {
      userPreferencesService = UserPreferencesService((value[0] as SharedPreferences?)!);
      hasLightSensor = value[1] as bool? ?? false;
    });
  }

  void _removeSplashscreen() {
    Future.wait([
      equipmentProfilesStorageServiceCompleter.future,
      filmsStorageServiceCompleter.future,
    ]).then((_) {
      FlutterNativeSplash.remove();
    });
  }
}
