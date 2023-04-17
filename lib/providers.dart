import 'package:flutter/material.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/ev_source_type_provider.dart';
import 'package:lightmeter/providers/metering_screen_layout_provider.dart';
import 'package:lightmeter/providers/stop_type_provider.dart';
import 'package:lightmeter/providers/supported_locale_provider.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
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
          return IAPProductsProvider(
            child: InheritedWidgetBase<Environment>(
              data: env.copyWith(hasLightSensor: snapshot.data![1] as bool),
              child: InheritedWidgetBase<UserPreferencesService>(
                data: UserPreferencesService(snapshot.data![0] as SharedPreferences),
                child: InheritedWidgetBase<LightSensorService>(
                  data: const LightSensorService(LocalPlatform()),
                  child: InheritedWidgetBase<CaffeineService>(
                    data: const CaffeineService(),
                    child: InheritedWidgetBase<HapticsService>(
                      data: const HapticsService(),
                      child: InheritedWidgetBase<VolumeEventsService>(
                        data: const VolumeEventsService(LocalPlatform()),
                        child: InheritedWidgetBase<PermissionsService>(
                          data: const PermissionsService(),
                          child: MeteringScreenLayoutProvider(
                            child: StopTypeProvider(
                              child: EquipmentProfileProvider(
                                child: EvSourceTypeProvider(
                                  child: SupportedLocaleProvider(
                                    child: ThemeProvider(
                                      child: Builder(
                                        builder: (context) => builder(context, true),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
