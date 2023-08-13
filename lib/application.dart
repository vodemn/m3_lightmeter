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
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application extends StatelessWidget {
  final Environment env;

  const Application(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        SharedPreferences.getInstance(),
        const LightSensorService(LocalPlatform()).hasSensor(),
      ]),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          return ServicesProvider(
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
                  builder: (context) {
                    final theme = themeFrom(
                      UserPreferencesProvider.primaryColorOf(context),
                      UserPreferencesProvider.brightnessOf(context),
                    );
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
