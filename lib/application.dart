import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/ev_source_type_provider.dart';
import 'package:lightmeter/providers/metering_screen_layout_provider.dart';
import 'package:lightmeter/providers/stop_type_provider.dart';
import 'package:lightmeter/providers/supported_locale_provider.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application extends StatelessWidget {
  final Environment env;

  const Application(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        SharedPreferences.getInstance(),
        Platform.isAndroid ? const LightSensorService().hasSensor() : Future.value(false),
      ]),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          return MultiProvider(
            providers: [
              Provider.value(value: env.copyWith(hasLightSensor: snapshot.data![1] as bool)),
              Provider(
                  create: (_) => UserPreferencesService(snapshot.data![0] as SharedPreferences)),
              Provider(create: (_) => const CaffeineService()),
              Provider(create: (_) => const HapticsService()),
              Provider(create: (_) => PermissionsService()),
              Provider(create: (_) => const LightSensorService()),
            ],
            child: MeteringScreenLayoutProvider(
              child: StopTypeProvider(
                child: EquipmentProfileProvider(
                  child: EvSourceTypeProvider(
                    child: SupportedLocaleProvider(
                      child: ThemeProvider(
                        builder: (context, _) => _AnnotatedRegionWrapper(
                          child: MaterialApp(
                            theme: context.watch<ThemeData>(),
                            locale: Locale(context.watch<SupportedLocale>().intlName),
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
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _AnnotatedRegionWrapper extends StatelessWidget {
  final Widget child;

  const _AnnotatedRegionWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final systemIconsBrightness = ThemeData.estimateBrightnessForColor(
      context.watch<ThemeData>().colorScheme.onSurface,
    );
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            systemIconsBrightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: systemIconsBrightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: systemIconsBrightness,
      ),
      child: child,
    );
  }
}
