import 'package:flutter/material.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/service_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LightmeterProviders extends StatelessWidget {
  final Environment env;
  final Widget Function(BuildContext context, bool ready) builder;

  const LightmeterProviders({required this.env, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        SharedPreferences.getInstance(),
        const LightSensorService(LocalPlatform()).hasSensor(),
      ]),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          return ServiceProvider(
            caffeineService: const CaffeineService(),
            environment: env.copyWith(hasLightSensor: snapshot.data![1] as bool),
            hapticsService: const HapticsService(),
            lightSensorService: const LightSensorService(LocalPlatform()),
            permissionsService: const PermissionsService(),
            userPreferencesService: UserPreferencesService(snapshot.data![0] as SharedPreferences),
            volumeEventsService: const VolumeEventsService(LocalPlatform()),
            child: UserPreferencesProvider(
              child: EquipmentProfileProvider(
                child: Builder(
                  builder: (context) => builder(context, true),
                ),
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return Center(child: Text(snapshot.error!.toString()));
        }
        return builder(context, false);
      },
    );
  }
}
