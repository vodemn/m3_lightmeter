import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/light_sensor_service.dart';
import 'data/permissions_service.dart';
import 'data/shared_prefs_service.dart';
import 'environment.dart';
import 'generated/l10n.dart';
import 'providers/ev_source_type_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/metering/flow_metering.dart';
import 'screens/settings/flow_settings.dart';
import 'utils/stop_type_provider.dart';

class Application extends StatelessWidget {
  final Environment env;

  const Application(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        SharedPreferences.getInstance(),
        Platform.isAndroid ? LightSensor.hasSensor : Future.value(false),
      ]),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          return MultiProvider(
            providers: [
              Provider.value(value: env.copyWith(hasLightSensor: snapshot.data![1] as bool)),
              Provider(create: (_) => UserPreferencesService(snapshot.data![0] as SharedPreferences)),
              Provider(create: (_) => const CaffeineService()),
              Provider(create: (_) => const HapticsService()),
              Provider(create: (_) => PermissionsService()),
              Provider(create: (_) => const LightSensorService()),
            ],
            child: StopTypeProvider(
              child: EvSourceTypeProvider(
                child: ThemeProvider(
                  builder: (context, _) {
                    final systemIconsBrightness = ThemeData.estimateBrightnessForColor(
                      context.watch<ThemeData>().colorScheme.onSurface,
                    );
                    return AnnotatedRegion(
                      value: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: systemIconsBrightness == Brightness.light
                            ? Brightness.dark
                            : Brightness.light,
                        statusBarIconBrightness: systemIconsBrightness,
                        systemNavigationBarColor: context.watch<ThemeData>().colorScheme.surface,
                        systemNavigationBarIconBrightness: systemIconsBrightness,
                      ),
                      child: MaterialApp(
                        theme: context.watch<ThemeData>(),
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
        }
        return const SizedBox();
      },
    );
  }
}
