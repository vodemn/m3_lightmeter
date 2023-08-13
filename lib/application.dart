import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';

class Application extends StatelessWidget {
  final Environment env;

  const Application(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return LightmeterProviders(
      env: env,
      builder: (context, ready) {
        if (ready) {
          final theme = themeFrom(
            UserPreferencesProvider.primaryColorOf(context),
            UserPreferencesProvider.brightnessOf(context),
          );
          final systemIconsBrightness =
              ThemeData.estimateBrightnessForColor(theme.colorScheme.onSurface);
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness:
                  systemIconsBrightness == Brightness.light ? Brightness.dark : Brightness.light,
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
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
