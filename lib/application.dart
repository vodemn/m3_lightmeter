import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/ev_source_type.dart';
import 'data/permissions_service.dart';
import 'data/shared_prefs_service.dart';
import 'generated/l10n.dart';
import 'res/theme.dart';
import 'screens/metering/flow_metering.dart';
import 'screens/settings/screen_settings.dart';
import 'utils/stop_type_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Application extends StatelessWidget {
  final EvSourceType evSource;

  const Application(this.evSource, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          return MultiProvider(
            providers: [
              Provider(create: (_) => UserPreferencesService(snapshot.data!)),
              Provider(create: (_) => const HapticsService()),
              Provider(create: (_) => PermissionsService()),
              Provider.value(value: evSource),
            ],
            child: StopTypeProvider(
              child: ThemeProvider(
                builder: (context, _) {
                  final systemIconsBrightness =
                      ThemeData.estimateBrightnessForColor(context.watch<ThemeData>().colorScheme.onSurface);
                  return AnnotatedRegion(
                    value: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness:
                          systemIconsBrightness == Brightness.light ? Brightness.dark : Brightness.light,
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
                        "settings": (context) => const SettingsScreen(),
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
